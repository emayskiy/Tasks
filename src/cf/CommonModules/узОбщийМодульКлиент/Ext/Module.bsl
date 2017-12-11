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

Процедура СоздатьФайлДляЗадачиНаДиске(Массив) Экспорт
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();	
	Каталог = ПолучитьКаталогПользователя(Пользователь);
	
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
		
		НастройкиДляСозданияИерархии = узОбщийМодульСервер.ПолучитьНастройкиДляСозданияФайлаДляЗадачи(СтрокаМассива,Каталог);
		ПолныйПутьЗадачи = НастройкиДляСозданияИерархии.ПолныйПутьЗадачи;
		
		Если НЕ ЗначениеЗаполнено(ПолныйПутьЗадачи) Тогда
			Сообщить("Ошибка! Не удалось получить путь для задачи "+СтрокаМассива);
			Возврат;
		КонецЕсли;
		
		//ОбъедененныйПуть = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог) + ПолныйПутьЗадачи;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьИерархиюЗадачНаДиске_Продолжение", ЭтотОбъект,НастройкиДляСозданияИерархии);
		НачатьСозданиеКаталога(ОписаниеОповещения, ПолныйПутьЗадачи);
		
	КонецЦикла;
		
КонецПроцедуры

Процедура СоздатьИерархиюЗадачНаДиске_Продолжение(ИмяКаталога, ДополнительныеПараметры) Экспорт
	
	КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если НЕ КаталогНаДиске.Существует() Тогда
		узОбщийМодульСервер.узСообщить("Не удалось создать файл для задачи на диске",94);
		Возврат;
	КонецЕсли;	
	
	ИмяДляФайлаЗадачи = ДополнительныеПараметры.ИмяДляФайлаЗадачи;
	
	ФайлНаДиске = Новый Файл(ИмяДляФайлаЗадачи);
	Если ФайлНаДиске.Существует() Тогда
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Файл уже существует %1",95);
		пТекстСообщения = СтрШаблон(пТекстСообщения,ИмяДляФайлаЗадачи);		
		Сообщить(пТекстСообщения);
		Возврат;
	КонецЕсли;	
	
	ШаблонПоУмолчанию = ДополнительныеПараметры.ШаблонПоУмолчанию;
	ШаблонПоУмолчанию.Записать(ИмяДляФайлаЗадачи);	
	
	пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Создан файл %1",93);
	пТекстСообщения = СтрШаблон(пТекстСообщения,ИмяДляФайлаЗадачи);		
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

Процедура ОткрытьПапкуЗадачиНаДиске(Массив) Экспорт
	
	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();	
	Каталог = ПолучитьКаталогПользователя(Пользователь);
	
	Если НЕ ЗначениеЗаполнено(Каталог) Тогда
		
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("ВНИМАНИЕ! Для открытия задачи на диске "
			+"не указан реквизит [Каталог пользователя] в справочнике пользователи",97);
		Сообщить(пТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаМассива Из Массив Цикл
		
		КодЗадачи = узОбщийМодульСервер.ЗначениеРеквизитаОбъекта(СтрокаМассива, "Код");
		Код = ""+Формат(КодЗадачи,"ЧГ=0");
		
		Разделитель = ПолучитьРазделительПути();
		
		Если НЕ СтрЗаканчиваетсяНа(Каталог, Разделитель) Тогда
			 Каталог = Каталог + Разделитель;
		КонецЕсли;	
		 
		МаскаПоиска = "*#"+Код+"*";
		МассивФайлов = НайтиФайлы(Каталог, МаскаПоиска, Истина);
		
		Если МассивФайлов.Количество() = 0 Тогда
			пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Не найдена папка с задачей #%1 в каталоге %2",98);
			пТекстСообщения = СтрШаблон(пТекстСообщения, Код, Каталог);	
			Сообщить(пТекстСообщения);

			Продолжить;
		КонецЕсли;	
		
		Каталоги = Новый Массив;	
		Для каждого СтрокаМассива Из МассивФайлов Цикл
			Если СтрокаМассива.ЭтоКаталог() Тогда
				Каталоги.Добавить(СтрокаМассива);
			КонецЕсли;
		КонецЦикла;
		
		Если Каталоги.Количество() > 1 Тогда
			пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Найдено более одной папки для задачи #%1 в каталоге %2",99);
			пТекстСообщения = СтрШаблон(пТекстСообщения, Код, Каталог);	
			Сообщить(пТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПапкуЗадачиНаДиске_Продолжение", ЭтотОбъект);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Каталоги[0].ПолноеИмя);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОткрытьПапкуЗадачиНаДиске_Продолжение(Результат, ДополнительныеПараметры) Экспорт
	
	ЗапуститьПриложение(Результат);
	
КонецПроцедуры

Функция ПолучитьКаталогПользователя(Пользователь)
	
	Возврат узОбщийМодульСервер.ЗначениеРеквизитаОбъекта(Пользователь, "узКаталогПользователя");
	
КонецФункции	

Процедура СписокПредметПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	Если (Строка = Неопределено) ИЛИ (ПараметрыПеретаскивания.Значение = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Для каждого ЭлементМассива Из ПараметрыПеретаскивания.Значение Цикл
			Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(ЭлементМассива) Тогда
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;	
КонецПроцедуры 

Процедура СписокПредметПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		ВзаимодействияВызовСервера.УстановитьПредметДляМассиваВзаимодействий(ПараметрыПеретаскивания.Значение,
			Строка, Истина);
			
	КонецЕсли;
	
	Оповестить("узВзаимодействия_ОбновитьПанельНавигации");
	
КонецПроцедуры 