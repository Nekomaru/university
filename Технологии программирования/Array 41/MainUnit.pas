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
  StringList: TStringList;      //������ ��� �������������� ������ � ������
  i: integer;                   //��������
  pairWithMaxSumIndex: integer; //������ ���� � ������������ ������
  maxPairSum: real;             //����������� ����� ����
  pairFirstElement: real;       //������ ������� ����
  pairSecondElement: real;      //������ ������� ����
begin
  //���������� ������������ ����� ���� ����� ��������� ����������� �����
  maxPairSum := -Infinity;

  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //����� ������ ������� ��������, ����� ����������
  for i := 0 to StringList.Count - 2 do
  begin
    //��������� � ��������� ���������� ������ ������� ����
    pairFirstElement := StrToFloat(StringList.Strings[i]);
    //��������� � ��������� ���������� ������ ������� ����
    pairSecondElement := StrToFloat(StringList.Strings[i + 1]);
    //���� ����� ������� ���� ������ ��� ������� ������������ ����� ����
    if pairFirstElement + pairSecondElement > maxPairSum then
    begin
      //�� ��������� ����� ������� ���� ��� ������������
      maxPairSum := pairFirstElement + pairSecondElement;
      //� ����� ��������� ������ ������� ����
      pairWithMaxSumIndex := i;
    end;
  end;
  //������� �������� ���������� ���� � ������������ ������
  ResultLabel.Caption := StringList.Strings[pairWithMaxSumIndex] + ' ' +
    StringList.Strings[pairWithMaxSumIndex + 1]; 
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '-7,3 8,4 12,1 14,5 2,1';
end;

end.
