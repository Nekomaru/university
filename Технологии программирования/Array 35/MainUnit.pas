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

uses Math;

{$R *.dfm}

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  StringList: TStringList;              //������ ��� �������������� ������ � ������
  i: integer;                           //��������
  minimalLocalMaximum: real;            //����������� ��������� ��������
  isCurElementIsLocalMaximum: boolean;  //�������� �� ������� ��������� ����������
begin
  //���������� ����������� �������� ������� ����� �������������
  minimalLocalMaximum := Infinity;

  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //����� ������ ������� ��������
  for i := 0 to StringList.Count - 1 do
  begin
    //� ������ ������ �������� �������, ��� ������� �� �������� ���������� ����������
    isCurElementIsLocalMaximum := false;

    //���� ������� ������� - ������� �������
    if i = 0 then
    begin
      //�� �� �������� ��������� �������� ���� �� ������ ������� ��������
      isCurElementIsLocalMaximum :=
        StrToFloat(StringList.Strings[0]) > StrToFloat(StringList.Strings[1]);
    end
    //���� ������� ������� - ��������� �������
    else if i = StringList.Count - 1 then
    begin
      //�� �� �������� ��������� ���������� ���� �� ������ ���������� ��������
      isCurElementIsLocalMaximum :=
        StrToFloat(StringList.Strings[StringList.Count - 1]) >
        StrToFloat(StringList.Strings[StringList.Count - 2]);
    end
    //�����
    else
    begin
      //������� �������� ��������� �������� ���� �� ������ ����� �������
      isCurElementIsLocalMaximum :=
        (StrToFloat(StringList.Strings[i]) > StrToFloat(StringList.Strings[i - 1])) and
        (StrToFloat(StringList.Strings[i]) > StrToFloat(StringList.Strings[i + 1]));
    end;
    //���� ������� �������� ��������� ����������
    //� ������ ���������� ���������� ���������� ���������
    if (isCurElementIsLocalMaximum) and
      (StrToFloat(StringList.Strings[i]) < minimalLocalMaximum) then
    begin
      //� ��� ��������
      minimalLocalMaximum := StrToFloat(StringList.Strings[i]);
    end;
  end;
  //������� ����������� ��������� ��������
  ResultLabel.Caption := FloatToStr(minimalLocalMaximum);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '2 12 -8,1 14,4 13,2 17,3';
end;

end.
