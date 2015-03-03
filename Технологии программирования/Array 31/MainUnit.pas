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
  elementCount: integer;    //���-�� ��������� ��������������� �������
begin
  //������� ����� � �����������
  ResultLabel.Caption := '';

  //���������� ������� ������������� 0 ���������
  elementCount := 0;

  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //����� ������ ������� �������� �������, ����� 0
  for i := StringList.Count - 1 downto 1 do
  begin
    //��������� ���������� �������
    curElement := StrToInt(StringList.Strings[i]);
    //��������� ������� �������
    prevElement := StrToInt(StringList.Strings[i - 1]);

    //���� ������� ������� ������ �����������
    if curElement > prevElement then
    begin
      //������� ������ �������� ��������
      ResultLabel.Caption := ResultLabel.Caption + ' ' + IntToStr(i);
      //����������� ���-�� ��������� ��������������� �������
      elementCount := elementCount + 1;
    end;
  end;
  //������� ����������� ';' � ���-�� ��������� ��������������� �������
  ResultLabel.Caption := ResultLabel.Caption + '; ' + IntToStr(elementCount);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '5 7 -12 22 44';
end;

end.
