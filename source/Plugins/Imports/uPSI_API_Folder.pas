unit uPSI_API_Folder;
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
  TPSImport_API_Folder = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAPI_Folder(CL: TPSPascalCompiler);
procedure SIRegister_API_Folder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAPI_Folder(CL: TPSRuntimeClassImporter);
procedure RIRegister_API_Folder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   APIBase
  ,MessagesLog
  ,API_Folder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_API_Folder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAPI_Folder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAPIBase', 'TAPI_Folder') do
  with CL.AddClassN(CL.FindClass('TAPIBase'),'TAPI_Folder') do
  begin
    RegisterMethod('Function Exists( aFolder : String) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_API_Folder(CL: TPSPascalCompiler);
begin
  SIRegister_TAPI_Folder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TAPI_Folder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAPI_Folder) do
  begin
    RegisterMethod(@TAPI_Folder.Exists, 'Exists');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_API_Folder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAPI_Folder(CL);
end;

 
 
{ TPSImport_API_Folder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Folder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_API_Folder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_API_Folder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_API_Folder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
