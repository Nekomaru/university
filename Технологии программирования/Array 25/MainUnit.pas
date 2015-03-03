unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Math;

type
  TMainForm = class(TForm)
    ArrayLabel: TLabel;
    ArrayEdit: TEdit;
    RunButton: TButton;
    DLabel: TLabel;
    procedure RunButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  StringList: TStringList;  //������ ��� �������������� ������ � ������
  i: integer;               //��������
  D: real;               //�����������
  First: integer;           //������ ������� �������
  epsilon: real;
  foo: real;
begin
  //������ �������� ���������
  epsilon := 0.0001;

  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //��������� ������ ������� �������
  First := StrToInt(StringList.Strings[0]);

  //��������� ��������� �����������
  D := StrToFloat(StringList.Strings[1]) / First;

  //����� ������ ������� �������� �������, ����� 1 � 0
  for i := 2 to StringList.Count - 1 do
  begin
    //���� ������� ������� �������� ����������
    if StrToInt(StringList.Strings[i]) <> First * Power(D, i) then
    begin
      //�� ������� ����
      DLabel.Caption := '0';
      //� ������� �� ���������
      Exit;
    end;
  end;

  //������� �����������
  DLabel.Caption := FloatToStr(D);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '3 6 12 24 48';
end;

end.
