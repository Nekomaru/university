library ND;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes;

{$R *.res}


 function f(fi, fi0 : real) : real;
  begin
    result := 1 / sqrt(cos(fi) - cos(fi0));
  end;

  function Period(value: real; count: Integer) : real; stdcall;
  var
    fi0 : real;
    h, i : real;
    sum : real;
  begin
    fi0 := value / 180 * pi;
//    h := fi0 / 50000000;
    h := fi0 / count;
    i := h/2;
    sum := 0;
    while i < fi0 - h do
      begin
        sum := sum + (f(i, fi0) * h);
        i := i + h;
      end;
    Result := (4/sqrt(2*(9.81)))*sum;
  end;

exports Period;
begin
end.
 