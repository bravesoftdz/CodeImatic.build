unit uPSI_API_Task;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_API_Task = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAPI_Task(CL: TPSPascalCompiler);
procedure SIRegister_TTask(CL: TPSPascalCompiler);
procedure SIRegister_API_Task(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_Task(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTask(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_Task(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   APIBase
  ,NovusWindows
  ,API_Output
  ,Plugin_TaskRunner
  ,API_Task
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_Task]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAPI_Task(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAPIBase', 'TAPI_Task') do
  with CL.AddClassN(CL.FindClass('TAPIBase'),'TAPI_Task') do
  begin
    RegisterMethod('Function AddTask( const aProcedureName : String) : TTask');
    RegisterMethod('Function RunTarget( const aProcedureName : String) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTask') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTask') do
  begin
    RegisterProperty('ProcedureName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_API_Task(CL: TPSPascalCompiler);
begin
  SIRegister_TTask(CL);
  SIRegister_TAPI_Task(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTaskProcedureName_W(Self: TTask; const T: String);
begin Self.ProcedureName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTaskProcedureName_R(Self: TTask; var T: String);
begin T := Self.ProcedureName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAPI_Task(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_Task) do
  begin
    RegisterMethod(@TAPI_Task.AddTask, 'AddTask');
    RegisterMethod(@TAPI_Task.RunTarget, 'RunTarget');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTask) do
  begin
    RegisterPropertyHelper(@TTaskProcedureName_R,@TTaskProcedureName_W,'ProcedureName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_API_Task(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTask(CL);
  RIRegister_TAPI_Task(CL);
end;

 
 
{ TPSImport_API_Task }
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Task.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_Task(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Task.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_Task(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
