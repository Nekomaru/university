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
    KLabel: TLabel;
    KEdit: TEdit;
    LEdit: TEdit;
    LLabel: TLabel;
    AverageLabel: TLabel;
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
  Sum: Real;       //�����, ������� ��������������
  StringList: TStringList;  //������ ��� �������������� ������ � ������
  i: integer;               //��������
  K, L: Real;
  ElementCount: integer;    //���-�� ��������� �� ������� ����� ���������
begin
  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //���������� ����� ��������� ����� ����
  Sum := 0;
  //� ���-�� ���������, ������� �������������� ������� ����� ���������, �����
  //����� ���������� �������
  ElementCount := StringList.Count;

  //��������� K
  K := StrToInt(KEdit.Text);
  //��������� L
  L := StrToInt(LEdit.Text);

  //����� ������ ������� �������� �������
  for i := 0 to StringList.Count - 1 do
  begin
    //��������� ��������� �� �� �� ��������� ��������� [K, L]
    if (i < K) or (i > L) then
    begin
      //���� ��������� �� � ����� ����� ���������� ������� �������
      Sum := Sum + StrToFloat(StringList.Strings[i]);
    end
    else
    begin
      //����� ��������� ���-�� ���������, ������� �������������� ������� ����� ���������
      ElementCount := ElementCount - 1;
    end;
  end;
  //����� ����� ��������� �� �� ���-�� � ������� ������������ ��������
  AverageLabel.Caption := '������� ��������������: ' + FloatToStr(Sum / ElementCount);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '1 2 3 4 5 6';
  KEdit.Text := '2';
  LEdit.Text := '3';
end;

end.
