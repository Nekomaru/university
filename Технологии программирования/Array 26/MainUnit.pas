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
  StringList: TStringList;  //объект дл€ преобразовани€ строки в массив
  i: integer;               //итератор
  prevElement: integer;     //предыдущий элемент
  curElement: integer;      //текущий элемент
begin
  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем раздел€ющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждего элемента массива, кроме 0
  for i := 1 to StringList.Count - 1 do
  begin
    //сохран€ем предыдущий элемент
    curElement := StrToInt(StringList.Strings[i]);
    //сохран€ем текущий элемент
    prevElement := StrToInt(StringList.Strings[i - 1]);
    //провер€ем не нарушает ли текущий элемент последовательность
    if (curElement mod 2) = (prevElement mod 2) then
    begin
      //если нарушает, то выводим его индекс
      ResultLabel.Caption := IntToStr(i);
      //и выходим из процедуры
      Exit;
    end;
  end;
  //иначе выводим ноль
  ResultLabel.Caption := '0';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //»нициализируем поле ввода
  ArrayEdit.Text := '2 3 2 15 22 23';
end;

end.
