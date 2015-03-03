unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    ArrayLabel: TLabel;
    ArrayEdit: TEdit;
    RunButton: TButton;
    ResultLabel: TLabel;
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
  prevElement: integer;     //���������� �������
  curElement: integer;      //������� �������
begin
  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //����� ������ ������� �������� �������, ����� 0
  for i := 1 to StringList.Count - 1 do
  begin
    //��������� ���������� �������
    curElement := StrToInt(StringList.Strings[i]);
    //��������� ������� �������
    prevElement := StrToInt(StringList.Strings[i - 1]);
    //��������� �� �������� �� ������� ������� ������������������
    if (curElement mod 2) = (prevElement mod 2) then
    begin
      //���� ��������, �� ������� ��� ������
      ResultLabel.Caption := IntToStr(i);
      //� ������� �� ���������
      Exit;
    end;
  end;
  //����� ������� ����
  ResultLabel.Caption := '0';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '2 3 2 15 22 23';
end;

end.
