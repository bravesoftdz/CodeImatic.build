unit Runtime;

interface

Uses Project, MessagesLog, Config, NovusVersionUtils, System.SysUtils,
     uPSRuntime,  Plugins, dialogs, NovusDateStringUtils, uPSCompiler ;

type
   tRuntime = class
   protected
   private
     fImp:  TPSRuntimeClassImporter;
     foMessagesLog: tMessagesLog;
     foProject: tProject;
     foPlugins: TPlugins;
 //    fdtStartBuild: tDatetime;
  //   fdtEndBuild: tDatetime;
   public
     function RunEnvironment: Boolean;

     property oMessagesLog: tMessagesLog
       read foMessagesLog
       write foMessagesLog;

     property oPlugins: TPlugins
       read foPlugins
       write foPlugins;

     property oProject: tProject
       read foProject
       write foProject;

    // property  StartBuild: tDatetime
     //  read fdtStartBuild
    //   write fdtStartBuild;

    // property  EndBuild: tDatetime
    //   read fdtEndBuild
    //   write fdtEndBuild;

   end;

   Var
     oRuntime: tRuntime;


   const cTimeformat = 'hh:mm:ss.zzz';


implementation

uses ScriptEngine;

function tRuntime.RunEnvironment: Boolean;
var
  liIndex, i, x: integer;
  loProjectItem: tProjectItem;
  loScriptEngine: TScriptEngine;
begin
  foProject := tProject.Create;

  foProject.LoadProjectFile(oConfig.ProjectFileName, oConfig.ProjectConfigFileName);

  if foProject.MessageslogPath = '' then foProject.MessageslogPath := foProject.GetWorkingdirectory;

  FoMessagesLog := tMessagesLog.Create(foProject.MessageslogPath + oConfig.MessageslogFile, foProject.OutputConsole);

  FoMessagesLog.DateTimeMask := FormatSettings.ShortDateFormat + ' '+ cTimeformat;

  FoMessagesLog.OpenLog(true);

  if not FoMessagesLog.IsFileOpen then
    begin
      foProject.Free;

      WriteLn(FoMessagesLog.Filename + ' log file cannot be created.');

      Exit;
    end;

  FoMessagesLog.WriteLog('Zautomatic - � Copyright Novuslogic Software 2016 All Rights Reserved');
  FoMessagesLog.WriteLog('Version: ' + TNovusVersionUtils.GetFullVersionNumber);

  FoMessagesLog.WriteLog('Project:' + foProject.ProjectFileName);
  if (foProject.oProjectConfig.ProjectConfigFileName <> '') then
    FoMessagesLog.WriteLog('Projectconfig:' + foProject.oProjectConfig.ProjectConfigFileName);

  FoMessagesLog.WriteLog('Messagelog file: ' + FoMessagesLog.Filename);

  if oConfig.CompileOnly then
    FoMessagesLog.WriteLog('Option:Compile Only.')
  else
    FoMessagesLog.WriteLog('Option:Compile and Execute.');
  FImp := TPSRuntimeClassImporter.Create;
  foPlugins := TPlugins.Create(FoMessagesLog, FImp);

  foPlugins.LoadPlugins;

  foPlugins.RegisterImports;

  StartBuild := Now;

  for I := 0 to foProject.oProjectItemList.Count - 1 do
    begin
      loProjectItem := tProjectItem(foProject.oProjectItemList.items[i]);

      FoMessagesLog.WriteLog('Project Item:' + loProjectItem.ItemName);


      if Not FileExists(loProjectItem.ProjectFileName) then
        begin
          FoMessagesLog.WriteLog('projectfilename ' + loProjectItem.ProjectFileName+ ' cannot be found.');

          Continue;
        end
     else
       begin
          FoMessagesLog.WriteLog('Project Filename:' + loProjectItem.ProjectFileName);


          loProjectItem.BuildStatus := TBuildStatus.bsNone;
          FoMessagesLog.ProjectItem := loProjectItem;

          loProjectItem.StartBuild := Now;

          FoMessagesLog.WriteLog('Build started ' + FoMessagesLog.FormatedNow(loProjectItem.StartBuild));

          loScriptEngine := TScriptEngine.Create(FoMessagesLog, FImp, FoPlugins);

          loScriptEngine.LoadScript(loProjectItem.ProjectFileName);

          loScriptEngine.ExecuteScript(oConfig.CompileOnly);

          loProjectItem.EndBuild := Now;

          if FoMessagesLog.ProjectItem.BuildStatus <> TBuildStatus.bsFailed then
            begin
              if FoMessagesLog.ProjectItem.BuildStatus <> TBuildStatus.bsErrors then
                FoMessagesLog.WriteLog('Build succeeded: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild))
              else
                FoMessagesLog.WriteLog('Build with errors: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild));
            end
          else
            FoMessagesLog.WriteLog('Build failed: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild));

          FoMessagesLog.WriteLog('Build Duration: ' + FormatDateTime(cTimeformat, loProjectItem.EndBuild-loProjectItem.StartBuild));

          FoMessagesLog.ProjectItem := NIL;

          loScriptEngine.Free;
        end;
    end;

  EndBuild := Now;

  // Build Time Report
  FoMessagesLog.WriteLog('Build Time Report');

  for I := 0 to foProject.oProjectItemList.Count - 1 do
    begin
      loProjectItem := tProjectItem(foProject.oProjectItemList.items[i]);

      (*
      if Not loProjectItem.Failed then
        begin
          if Not loProjectItem.Errors then
             FoMessagesLog.WriteLog(loProjectItem.ItemName + ' build succeeded: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild))
           else
                FoMessagesLog.WriteLog('Build with errors: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild));
            end
          else
            FoMessagesLog.WriteLog('Build failed: ' + FoMessagesLog.FormatedNow(loProjectItem.EndBuild));

      *)


      FoMessagesLog.WriteLog(loProjectItem.ItemName);
    end;

  FImp.Free;

  FoMessagesLog.CloseLog;

  FoMessagesLog.Free;

  foPlugins.Free;

  foProject.Free;
end;

Initialization
  oRuntime := tRuntime.Create;

finalization
  oRuntime.Free;

end.
