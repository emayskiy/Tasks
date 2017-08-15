﻿Функция Удалить_ПолучитьТекстHTMLMarkdown(ТекстСодержания) Экспорт
	
	//РезультатФункции = узОбщийМодульСервер.ПолучитьМакетыMardown(ТекстСодержания);
	// 
	//ТекстHTMLМакет = РезультатФункции.ТекстHTMLМакет;
	//Возврат ТекстHTMLМакет;
КонецФункции 

Функция УстановитьТекстВБуферОбмена(ТекстДляКопирования) Экспорт
    пОбъект = Новый COMОбъект("htmlfile");
    пОбъект.ParentWindow.ClipboardData.Setdata("Text", ТекстДляКопирования);
	
	пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Скопирован в буфер: %1",86);
	пТекстСообщения = СтрШаблон(пТекстСообщения,ТекстДляКопирования);
	ПоказатьОповещениеПользователя(пТекстСообщения);
	
    Возврат ТекстДляКопирования;
КонецФункции 

Процедура СоздатьИерархиюЗадачНаДиске(Массив) Экспорт
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();	
	Каталог = узОбщийМодульСервер.ЗначениеРеквизитаОбъекта(Пользователь, "узКаталогПользователя");
	
	Если НЕ ЗначениеЗаполнено(Каталог) Тогда
		Каталог = ВыбратьКаталог(РежимДиалогаВыбораФайла.ВыборКаталога, "Выберите каталог");
		
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("ВНИМАНИЕ! Чтобы не указывать "
			+"каждый раз каталог для задач, его необходимо задать в реквизите [Каталог пользователя] в справочнике пользователи",92);
		Сообщить(пТекстСообщения);
		
		Если Каталог = Неопределено Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого СтрокаМассива Из Массив Цикл
		
		ПолныйПутьЗадачи = узОбщийМодульСервер.ПолучитьПолныйПутьЗадачи(СтрокаМассива);
		
		Если НЕ ЗначениеЗаполнено(ПолныйПутьЗадачи) Тогда
			Сообщить("Ошибка! Не удалось получить путь для задачи "+СтрокаМассива);
			Возврат;
		КонецЕсли;
		
		ОбъедененныйПуть = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог) + ПолныйПутьЗадачи;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьИерархиюЗадачНаДиске_Продолжение", ЭтотОбъект);
		НачатьСозданиеКаталога(ОписаниеОповещения, ОбъедененныйПуть);
		
	КонецЦикла;
		
КонецПроцедуры

Процедура СоздатьИерархиюЗадачНаДиске_Продолжение(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если КаталогНаДиске.Существует() Тогда
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Создан каталог %1",90);
	Иначе
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Не удалось создать каталог %1",91);
	КонецЕсли;	
	
	пТекстСообщения = СтрШаблон(пТекстСообщения,ИмяКаталога);		
	Сообщить(пТекстСообщения);	
КонецПроцедуры	

Функция ВыбратьКаталог(Режим, Заголовок)

    Диалог = Новый ДиалогВыбораФайла(Режим);
    Диалог.Заголовок = Заголовок;
    Диалог.ПредварительныйПросмотр = Ложь;

    Если Диалог.Выбрать() Тогда
        Возврат Диалог.Каталог;
    КонецЕсли;

КонецФункции
