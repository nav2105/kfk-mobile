
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьПоказателиКачества();
	ВывестиПоказателиНаФорму();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьКартикуОценки();
	ОбщегоНазначенияКлиент.ИнициализироватьСканер();
	КаталогФото =  ОбщегоНазначенияКлиент.КаталогФото();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Barcode"  Тогда 
		
		ОбработатьШтрихкоды(Параметр, Источник);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка) И ЗначениеЗаполнено(СсылкаНаДокумент) Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаДокумент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписьОценкаКачества");

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОбщегоНазначенияКлиент.ОтключитьСканер();

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонтейнерыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КартинкаСохранитьНажатие(Элемент)
	
	Если Объект.Оценка <= 3 И Объект.Фото.Количество() = 0 Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "При оценка 3 и ниже необходимо приложить фото";
		Сообщение.Сообщить();
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ГруппаФото;
		Возврат;
	КонецЕсли;
		
	Если ПроверитьЗаполнение() Тогда 
		Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура КартинкаСканированиеШКНажатие(Элемент)
		
	СканированиеШК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеШК(Команда)
	
	#Если МобильноеПриложениеКлиент  Тогда
		
		Если Не СредстваМультимедиа.ПоддерживаетсяСканированиеШтрихКодов() Тогда 
			Сообщить("Устройство не поддерживает сканирование камерой");
			Возврат;
		КонецЕсли;
		
		ОбработчикСканирования = Новый ОписаниеОповещения("СканированиеЗавершение", ЭтаФорма);	
		ОбработчикЗакрытия = Новый ОписаниеОповещения("ЗакрытиеСканированияЗавершение", ЭтаФорма);
		
		Попытка
			СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Наведите камеру на штрихкод. Можно отсканировать сразу все контейнеры.", ОбработчикСканирования, ОбработчикЗакрытия, ТипШтрихКода.Линейный);
		Исключение
			СредстваМультимедиа.ЗакрытьСканированиеШтрихКодов();
			СредстваМультимедиа.ПоказатьСканированиеШтрихКодов("Наведите камеру на штрихкод. Можно отсканировать сразу все контейнеры.", ОбработчикСканирования, ОбработчикЗакрытия, ТипШтрихКода.Линейный);
		КонецПопытки;
		
	#КонецЕсли
	
КонецПроцедуры


&НаКлиенте
Процедура РучнойВводШК(Команда)
		
	ОткрытьФорму("ОбщаяФорма.РучнойВводШК",,,,,,Новый ОписаниеОповещения("РучноВводШКЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура РучноВводШКЗавершение(Результат, ДопПараметры = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда 
		Возврат;
	КонецЕсли;
	
	Оповестить("Barcode", Результат, "РучнойВводШК");
	
КонецПроцедуры

&НаКлиенте
Процедура СканированиеЗавершение(Штрихкод, Результат, Сообщение, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		Оповестить("Barcode", Штрихкод, "ФотоШК");
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеСканированияЗавершение(ДополнительныеПараметры) Экспорт
	
	//
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗначениеПоказателяПриИзменении(Элемент)
	
	Объект.КоличествоНесоответствий = Объект.ПоказателиКачества.Итог("Значение");
	РасчитатьПроцентНесоответсвия();
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерОбъекдиненнойПробыПриИзменении(Элемент)
	
	РасчитатьПроцентНесоответсвия();
	
КонецПроцедуры



&НаКлиенте
Процедура КоличествоНесоответствийПриИзменении(Элемент)
	
	РасчитатьПроцентНесоответсвия();
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация3Нажатие(Элемент)
	
	#Если МобильноеПриложениеКлиент Тогда
		
		ИндексНовогоФото = 0;
		ФайлФото = АдресНовогоФото(ИндексНовогоФото);

		НовВз = Новый ЗапускПриложенияМобильногоУстройства("android.media.action.IMAGE_CAPTURE");
		НовВз.ДополнительныеДанные.Добавить("output",ФайлФото,"Uri");

		Результат = НовВз.Запустить(Истина);
		Если Результат <> 0 Тогда
			Оповещение = Новый ОписаниеОповещения("ЗагрузитьФотоЗавершение", ЭтотОбъект, ИндексНовогоФото);
			НачатьПомещениеФайла(Оповещение,, ФайлФото, Ложь, ЭтаФорма.УникальныйИдентификатор);
			ДобавитьФотоВОчередьОбмена(СсылкаНаДокумент, ИндексНовогоФото, ФайлФото);  
			//Записать(Новый Структура("ОтправитьФото"));	 
			Записать();   
		Иначе
			УдалитьФайлы(ФайлФото);
		КонецЕсли;

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьSMS(Команда)
	
	#Если МобильноеПриложениеКлиент Тогда 		
		НомерТелефона = НомерТелефонаБригады(Объект.Бригада);
		//
		//Если Не ЗначениеЗаполнено(НомерТелефона) Тогда 
		//	Сообщить("Не указан номер телефона звеньевого")	
		//КонецЕсли;
		
		СообщениеSMS = Новый SMSСообщение;
		СообщениеSMS.Текст = "Оценка качества уборки: " + Строка(Объект.Оценка);
		СообщениеSMS.Получатели.Добавить(НомерТелефона);
		СредстваТелефонии.ПослатьSMS(СообщениеSMS, Истина);
		
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура КартинкаОценкаНажатие(Элемент)
	
	ОтправитьSMS(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыФормыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаФото И (Не ФотоВыведены) Тогда 
		Для Каждого СтрокаФото из Объект.Фото Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаФото.АдресНаДиске) Тогда 
				Продолжить;
			КонецЕсли;
			
			Оповещение = Новый ОписаниеОповещения("ВывестиФотоЗавершение", ЭтотОбъект, СтрокаФото.ПолучитьИдентификатор());
			Попытка
				НачатьПомещениеФайла(Оповещение,,СтрокаФото.АдресНаДиске,Ложь,ЭтаФорма.УникальныйИдентификатор);
			Исключение
			КонецПопытки;
			
		КонецЦикла;
		ФотоВыведены = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФотоНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Строки = Объект.Фото.НайтиСтроки(Новый Структура("ИмяЭлемента", Элемент.Имя));
	Если Строки.Количество() > 0 Тогда 
		ЗапуститьПриложение(Строки[0].АдресНаДиске);		
	КонецЕсли;
	
КонецПроцедуры

//@skip-warning
// подключаемая команда
&НаКлиенте
Процедура УдалитьФото(Команда)
	
	Строки = Объект.Фото.НайтиСтроки(Новый Структура("ИмяКомандыУдалить", Команда.Имя));
	Если Строки.Количество() > 0 Тогда
		Попытка
			УдалитьФайлы(Строки[0].АдресНаДиске);
		Исключение
		КонецПопытки;	
		УдалитьФотоНаСервере(Строки[0].ПолучитьИдентификатор());
	КонецЕсли;
		
КонецПроцедуры



#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

&НаКлиенте
Процедура ОбработатьШтрихкоды(Штрихкод, Источник)
	Если Лев(Штрихкод,2) = "HT" Тогда // сканирвоание бригады 
		
		НомерБригады = Прав(Штрихкод, СтрДлина(Штрихкод) - 2);
		НайденнаяБригада = ОбменВызовСервераПовтИсп.ПолучитьБригаду(НомерБригады);
		Если ЗначениеЗаполнено(НайденнаяБригада) Тогда 
			Объект.Бригада = НайденнаяБригада;	
			ТекущийЭлемент = Элементы.Бригада;
		КонецЕсли;
	Иначе	
		Строки = Объект.Контейнеры.НайтиСтроки(Новый Структура("Штрихкод", Штрихкод));
		Если Строки.Количество() > 0 Тогда 
			СтрокаКонтейнера = Строки[0];
		Иначе
			СтрокаКонтейнера = Объект.Контейнеры.Добавить();
			СтрокаКонтейнера.Штрихкод = Штрихкод;
			СтрокаКонтейнера.ШтрихкодОтсканирован = (Источник = "ПодключаемоеОборудование"); 
			СтрокаКонтейнера.ДатаДобавления = ТекущаяДата();
			Если ПроверитьЗаполнение() Тогда
				Записать();
			Иначе
				Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.Контейнеры.ТекущаяСтрока = СтрокаКонтейнера.ПолучитьИдентификатор();
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ГруппаКонтейнеры;
	КонецЕсли;

КонецПроцедуры



&НаСервере
Процедура ЗаполнитьПоказателиКачества()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	МАКСИМУМ(ОФ_ПоказателиКачества.Ссылка) КАК Показатель,
	                      |	ОФ_ПоказателиКачества.Наименование КАК Наименование
	                      |ИЗ
	                      |	Справочник.ОФ_ПоказателиКачества КАК ОФ_ПоказателиКачества
	                      |ГДЕ
	                      |	НЕ ОФ_ПоказателиКачества.ПометкаУдаления
	                      |
	                      |СГРУППИРОВАТЬ ПО
	                      |	ОФ_ПоказателиКачества.Наименование");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		
		Строки = Объект.ПоказателиКачества.НайтиСтроки(Новый Структура("Показатель", Выборка.Показатель));
		Если Строки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли; 
		
		СтрокаПоказателя = Объект.ПоказателиКачества.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПоказателя, Выборка); 
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПоказателиНаФорму()
	
	ИндексСтроки = 0;
	Для Каждого Строка из Объект.ПоказателиКачества Цикл 
		
		ИдентификаторСтроки = Формат(Строка.ПолучитьИдентификатор(), "ЧН=0; ЧГ=");
		
		ПолеВводаЗначения = Элементы.Добавить("ПолеВводаЗначения_" + ИдентификаторСтроки, Тип("ПолеФормы"), Элементы.ГруппаПоказатели);
		ПолеВводаЗначения.Вид = ВидПоляФормы.ПолеВвода;
		ПолеВводаЗначения.ПутьКДанным = "Объект.ПоказателиКачества["+Формат(ИндексСтроки, "ЧГ=")+"].Значение";
		ПолеВводаЗначения.Заголовок = Строка(Строка.Показатель);
		ПолеВводаЗначения.КнопкаРегулирования = Истина;
		ПолеВводаЗначения.Формат = "ЧН=' '";
		ПолеВводаЗначения.ФорматРедактирования = "ЧН=' '";
		ПолеВводаЗначения.УстановитьДействие("ПриИзменении", "Подключаемый_ЗначениеПоказателяПриИзменении");


		ИндексСтроки = ИндексСтроки + 1;
		
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура РасчитатьПроцентНесоответсвия()
		
	Если Объект.РазмерОбъединеннойПробы <> 0 Тогда 
		Объект.ПроцентНессответсвий = Объект.КоличествоНесоответствий / Объект.РазмерОбъединеннойПробы * 100;
	Иначе
		Объект.ПроцентНессответсвий = 0;	
	КонецЕсли;
	
	Объект.Оценка = ОценкаКачестваКлиентСервер.ПолучитьОценку(100 - Объект.ПроцентНессответсвий);	
	УстановитьКартикуОценки();
	
	//СтрокаКоличество = "Несоответсвия: " + Строка(Объект.КоличествоНесоответствий) + " (" + Строка(ПроцентНессответсвий) + "%)";	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКартикуОценки()
	
	Если Объект.Оценка > 0 И Объект.Оценка <= 5 Тогда   		
		Элементы.КартинкаОценка.Картинка 	= БиблиотекаКартинок["Цифра" + Строка(Объект.Оценка)];
		Элементы.КартинкаОценка1.Картинка 	= БиблиотекаКартинок["Цифра" + Строка(Объект.Оценка)];		
	Иначе
		Элементы.КартинкаОценка.Картинка = Новый Картинка;
		Элементы.КартинкаОценка1.Картинка = Новый Картинка;
	КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НомерТелефонаБригады(Бригада)

	Возврат Бригада.НомерТелефона;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьФотоЗавершение(Результат, Адрес, ФайлФото, ИндексНовогоФото) Экспорт
	
	СтрокаФото = Объект.Фото.Добавить();
	СтрокаФото.АдресНаДиске = ФайлФото; 
	СтрокаФото.АдресХранилища = Адрес;
	СтрокаФото.ИндексФото = ИндексНовогоФото;	
	
	СоздатьКартинкуДляФото(СтрокаФото);
		
	ФотоВыведены = Истина;	
	
КонецПроцедуры

&НаСервере
Процедура ВывестиФотоЗавершение(Результат, Адрес, ФайлФото, ИдентификаторСтроки) Экспорт
	
	СтрокаФото = Объект.Фото.НайтиПоИдентификатору(ИдентификаторСтроки);
	СтрокаФото.АдресХранилища = Адрес;	
	СоздатьКартинкуДляФото(СтрокаФото);	


КонецПроцедуры

&НаСервере
Функция СоздатьКартинкуДляФото(СтрокаФото)
	
	ИдентификаторСтроки = Формат(СтрокаФото.ПолучитьИдентификатор(), "ЧН=0; ЧГ=");
	
	Если СтрокаФото.НомерСтроки % 2 = 0 Тогда  
		ГруппаКартинок = Элементы.Колонка1;
	Иначе
		ГруппаКартинок = Элементы.Колонка2;	
	КонецЕсли;
	
	СтрокаФото.ИмяЭлемента = "ПолеФото_"+ИдентификаторСтроки;
	СтрокаФото.ИмяКомандыУдалить = "КомандаУдалить_"+ИдентификаторСтроки;
	
	ПолеКартинки = Элементы.Добавить(СтрокаФото.ИмяЭлемента, Тип("ПолеФормы"), ГруппаКартинок);
	ПолеКартинки.Вид = ВидПоляФормы.ПолеКартинки;
	//ПолеКартинки.ПутьКДанным = "Объект.Фото["+Формат(Индекс, "ЧГ=")+"].АдресХранилища";
	ПолеКартинки.ПутьКДанным = "Объект.Фото["+Формат(СтрокаФото.НомерСтроки-1, "ЧГ=")+"].АдресХранилища";
	ПолеКартинки.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	ПолеКартинки.РазмерКартинки  = РазмерКартинки.Пропорционально;
	ПолеКартинки.Гиперссылка = Истина;
	//ПолеКартинки.АвтоМаксимальнаяВысота = Ложь;
	//ПолеКартинки.МаксимальнаяВысота = 6;	
	ПолеКартинки.УстановитьДействие("Нажатие", "Подключаемый_ФотоНажатие");
	//ПолеКартинки.КонтекстноеМеню.Автозаполнение = Ложь;
	
    Команда = Команды.Добавить(СтрокаФото.ИмяКомандыУдалить);
    Команда.Действие  = "УдалитьФото";
    Команда.Заголовок = "Удалить фото";
		
	КнопкаУдалить = Элементы.Добавить(СтрокаФото.ИмяКомандыУдалить, Тип("КнопкаФормы"), ПолеКартинки.КонтекстноеМеню);
	КнопкаУдалить.Вид        = ВидКнопкиФормы.КнопкаКоманднойПанели;
	КнопкаУдалить.ИмяКоманды = СтрокаФото.ИмяКомандыУдалить;    
		
	Возврат ПолеКартинки.Имя;
	
КонецФункции

&НаКлиенте
Функция АдресНовогоФото(ИндексНовогоФото)
	
	СсылкаНаДокумент = Объект.Ссылка;
	Если Не ЗначениеЗаполнено(Объект.Номер) Тогда 
		ЗаполнитьНомерИСсылку();
	КонецЕсли;
	
	ИндексНовогоФото = 0;
	Для Каждого строка из Объект.Фото Цикл 
		ИндексНовогоФото = Макс(строка.ИндексФото, ИндексНовогоФото);		
	КонецЦикла;
	ИндексНовогоФото = ИндексНовогоФото + 1;
		
	Возврат КаталогФото 
					+ "/Score_"
					+ Формат(ТекущаяДата(), "ДФ=yyyyMMdd_") 
					+ Прав(Объект.Номер, 6) 
					+ "_" 
					+ Строка(ИндексНовогоФото) 
					+ ".jpg";
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНомерИСсылку()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.УстановитьНовыйНомер();
	Если ДокументОбъект.ЭтоНовый() Тогда
		СсылкаНаДокумент = Документы.ОФ_ОценкаКачестваУборкиУрожая.ПолучитьСсылку(Новый УникальныйИдентификатор());
		ДокументОбъект.УстановитьСсылкуНового(СсылкаНаДокумент);
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФотоНаСервере(ИдентификаторСтроки)
		
	СтрокаФото = Объект.Фото.НайтиПоИдентификатору(ИдентификаторСтроки);

	Элементы.Удалить(Элементы[СтрокаФото.ИмяЭлемента]);
	Объект.Фото.Удалить(СтрокаФото);
	Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьФотоВОчередьОбмена(Документ, ИндексФото, АдресНаДиске)
	
	РегистрыСведений.ОчередьФотоНаСервер.ДобавитьФото(Документ, ИндексФото, АдресНаДиске);
	
КонецПроцедуры


#КонецОбласти
