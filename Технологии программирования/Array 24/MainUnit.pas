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
  StringList: TStringList;  //объект дл€ преобразовани€ строки в массив
  i: integer;               //итератор
  D: integer;               //разность
  First: integer;           //первый элемент массива
begin
  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем раздел€ющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //сохран€ем первый элемент массива
  First := StrToInt(StringList.Strings[0]);

  //вычисл€ем возможную разность
  D := StrToInt(StringList.Strings[1]) - First;

  //берем индекс каждего элемента массива, кроме 1 и 0
  for i := 2 to StringList.Count - 1 do
  begin
    //если текущий элемент нарушает прогрессию
    if StrToInt(StringList.Strings[i]) <> First + i * D then
    begin
      //то выводим ноль
      DLabel.Caption := '0';
      //и выходим из процедуры
      Exit;
    end;
  end;

  //выводим разность
  DLabel.Caption := IntToStr(D);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //»нициализируем поле ввода
  ArrayEdit.Text := '1 4 7 10 13';
end;

end.
