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
  StringList: TStringList;                    //������ ��� �������������� ������ � ������
  i: integer;                                 //��������
  maxWantedElement: real;                     //����������� ������� ��������������� ��������
  isAtLeastOneWantedElementExist: boolean;    //���������� �� ���� �� ���� ������� ��������������� ��������
  isCurElementIsLocalExtremum: boolean;       //�������� �� ������� ������� ��������� �����������
  prevElement, curElement, nextElement: real; //����������, ������� � ��������� ������� ��������������
begin
  //���������� �� ������ �������� ���������������� �������� �� �������
  isAtLeastOneWantedElementExist := false;

  //���������� ������������ ������� ������� ����� ���������� ���������� ��������
  maxWantedElement := -Infinity;

  //������� ������, � ������� �������� ����� �� ��������� ������ ������ ������
  StringList := TStringList.Create;

  //��������� ����������� ������
  StringList.Delimiter := ' ';
  //��������� ������, ������� ����� ��������
  StringList.DelimitedText := ArrayEdit.Text;

  //����� ������ ������� ��������
  for i := 0 to StringList.Count - 1 do
  begin
    //� ������ ������ �������� �������, ��� ������� �� �������� ���������� �����������
    isCurElementIsLocalExtremum := false;

    //��������� ������� ������� � ��������� ����������
    curElement := StrToFloat(StringList.Strings[i]);

    //���� ������� ������� - ������� �������
    if i = 0 then
    begin
      //�� �� �������� ��������� ����������� ���� �� �� ����� ������� ��������
      isCurElementIsLocalExtremum :=
        curElement <> StrToFloat(StringList.Strings[1]);
    end
    //���� ������� ������� - ��������� �������
    else if i = StringList.Count - 1 then
    begin
      //�� �� �������� ��������� ����������� ���� �� �� ����� �������������� ��������
      isCurElementIsLocalExtremum :=
        curElement <> StrToFloat(StringList.Strings[StringList.Count - 2]);
    end
    //�����
    else
    begin
      //��������� ���������� ������� � ��������� ����������
      prevElement := StrToFloat(StringList.Strings[i - 1]);

      //��������� ��������� ������� � ��������� ����������
      nextElement := StrToFloat(StringList.Strings[i + 1]);

      //���� ������� ������� ����� ����������� ��� ����������
      if (prevElement = curElement) or (nextElement = curElement) then
      begin
        //�� �� ����� �� �������� ��������� �����������
        isCurElementIsLocalExtremum := false;
      end
      else
      begin
        //����� ������� �������� ��������� ��������� ���� �� ������ ��� ������ ��� ��� ��� ������
        isCurElementIsLocalExtremum :=
          (prevElement - curElement) / Abs(prevElement - curElement) =
          (nextElement - curElement) / Abs(nextElement - curElement);
      end;
    end;
    //���� ������� �� �������� ��������� �����������
    //� ������ ���������� ���������� �������� �� ����������� ��������� �����������
    if (not isCurElementIsLocalExtremum) and
      (StrToFloat(StringList.Strings[i]) > maxWantedElement) then
    begin
      //��������, ��� ���������� ��������, ������� �� �������� ���������� ������������
      isAtLeastOneWantedElementExist := true;
      //��������� ��� ��������
      maxWantedElement := curElement;
    end;
  end;

  //���� ���������� ���� �� ���� ������� �� ���������� ��������� �����������
  if isAtLeastOneWantedElementExist then
  begin
    //�� ������� ���
    ResultLabel.Caption := FloatToStr(maxWantedElement);
  end
  else
  begin
    //����� ������� 0
    ResultLabel.Caption := '0';
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //�������������� ���� �����
  ArrayEdit.Text := '-2 -3,4 -22 22,4 7';
end;

end.
