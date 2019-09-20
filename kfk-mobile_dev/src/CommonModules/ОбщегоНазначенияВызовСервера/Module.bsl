

// Устанавливает настройки по умолчанию на устройстве.
//
Процедура УстановитьПервоначальныеНастройки() Экспорт
	
	УстановитьКодУстройства();
	УстановитьДиагональЭкрана();
	УстановитьПараметрыОчисткиДанных();
	
	Узел = ПланыОбмена.ОбменССервером.ЭтотУзел();
	Если Не ЗначениеЗаполнено(Узел.Код) Тогда
		ОбъектУзла = Узел.ПолучитьОбъект();
		ОбъектУзла.Код = Константы.КодУстройства.Получить();
		ОбъектУзла.Наименование = ИмяКомпьютера();
		ОбъектУзла.Записать();	
		
		Константы.ВиброПриСканировании.Установить(Истина);
		Константы.ВыгружатьИнформациюОКлиенте.Установить(Истина);
			
	КонецЕсли;
	
	ОбменВызовСервераПовтИсп.ПолучитьЦентральныйУзелОбмена();
	
КонецПроцедуры

Процедура УстановитьДиагональЭкрана()

	#Если МобильноеПриложениеСервер Тогда

	Если Константы.ДиагональЭкрана.Получить() = 0 Тогда
		Инфо = ПолучитьИнформациюЭкрановКлиента();
		Если (Не Инфо = Неопределено) И Инфо.Количество() > 0 Тогда
			Диагональ = Окр(Sqrt(Pow(Инфо[0].Ширина, 2) + Pow(Инфо[0].Высота, 2))
				/ Инфо[0].DPI, 0);
			Константы.ДиагональЭкрана.Установить(Диагональ);
		КонецЕсли;
	КонецЕсли;

	#КонецЕсли

КонецПроцедуры

// Устанавливает уникальный код устройства для однозначной идентификации устройства в центральной базе.
//
Процедура УстановитьКодУстройства()

	Код = Константы.КодУстройства.Получить();

	Если Код = Неопределено Или ПустаяСтрока(Код) Тогда

		Код = Строка(Новый УникальныйИдентификатор());

		Константы.КодУстройства.Установить(Код);

	КонецЕсли;

КонецПроцедуры

Процедура УстановитьПараметрыОчисткиДанных()

	КоличествоДнейХраненияФото = Константы.КоличествоДнейХраненияФото.Получить();
	Если КоличествоДнейХраненияФото = 0 Тогда
		Константы.КоличествоДнейХраненияФото.Установить(7);
	КонецЕсли;

КонецПроцедуры

// Получает признаки необходимости данных для отправки.
//
// Параметры:
//  ДатаПоследнегоОбновления - Дата - Дата последнего удачного подключения к серверу;
//  ЕстьДанныеДляОтправки	 - Булево - Признак наличия данных для отправки.
//
Процедура ПолучитьДатуПоследнегоОбновленияИНаличиеДанныхДляОтправки(ДатаПоследнегоОбновления, ЕстьДанныеДляОтправки) Экспорт

	ДатаПоследнегоОбновления = Константы.ДатаПоследнегоОбновления.Получить();
	ЕстьДанныеДляОтправки    = Константы.ЕстьНеотправленныеДанные.Получить() Или Константы.ЕстьНеотправленныеФото.Получить();

КонецПроцедуры

Процедура УстановитьУсловноеОформлениеПоляДата(Форма, ИмяЭлементаФормы, ПутьКДаннымПоля) Экспорт
	
	// Для сегодняшнего дня используется представления "09:46".
	ЭлементОформления = Форма.УсловноеОформление.Элементы.Добавить();
	ЭлементОформления.Использование = Истина;
	ЭлементОформления.Представление = НСтр("ru = 'Представление даты сегодня: ""09:46""'");
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", "ДФ=ЧЧ:мм");
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Формат", "ДФ=ЧЧ:мм");
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(ИмяЭлементаФормы);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ЭлементОтбора.ПравоеЗначение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоЭтогоДня);
	
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ПутьКДаннымПоля);
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбора.ПравоеЗначение = Новый СтандартнаяДатаНачала(ВариантСтандартнойДатыНачала.НачалоСледующегоДня);
	
КонецПроцедуры

// Установить или обновить значение параметра ИмяПараметра динамического списка Список.
//
// Параметры:
//  Список          - ДинамическийСписок - реквизит формы, для которого требуется установить параметр.
//  ИмяПараметра    - Строка             - имя параметра динамического списка.
//  Значение        - Произвольный        - новое значение параметра.
//  Использование   - Булево             - признак использования параметра.
//
Процедура УстановитьПараметрДинамическогоСписка(Список, ИмяПараметра, Значение, Использование = Истина) Экспорт
	
	ЗначениеПараметраКомпоновкиДанных = Список.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	Если ЗначениеПараметраКомпоновкиДанных <> Неопределено Тогда
		Если Использование И ЗначениеПараметраКомпоновкиДанных.Значение <> Значение Тогда
			ЗначениеПараметраКомпоновкиДанных.Значение = Значение;
		КонецЕсли;
		Если ЗначениеПараметраКомпоновкиДанных.Использование <> Использование Тогда
			ЗначениеПараметраКомпоновкиДанных.Использование = Использование;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Добавить или заменить существующий элемент отбора.
//
// Параметры:
//  ОбластьПоискаДобавления - контейнер с элементами и группами отбора, например.
//                  Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
Процедура УстановитьЭлементОтбора(ОбластьПоискаДобавления,
								Знач ИмяПоля,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Представление = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	ЧислоИзмененных = ИзменитьЭлементыОтбора(ОбластьПоискаДобавления, ИмяПоля, Представление,
							ПравоеЗначение, ВидСравнения, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	
	Если ЧислоИзмененных = 0 Тогда
		Если ВидСравнения = Неопределено Тогда
			Если ТипЗнч(ПравоеЗначение) = Тип("Массив")
				Или ТипЗнч(ПравоеЗначение) = Тип("ФиксированныйМассив")
				Или ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
				ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
			Иначе
				ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			КонецЕсли;
		КонецЕсли;
		Если РежимОтображения = Неопределено Тогда
			РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		ДобавитьЭлементКомпоновкиСИдентификатором(ОбластьПоискаДобавления, ИмяПоля, ВидСравнения,
								ПравоеЗначение, Представление, Использование, РежимОтображения, ИдентификаторПользовательскойНастройки);
	КонецЕсли;
	
КонецПроцедуры

// Изменить элемент отбора с заданным именем поля или представлением.
//
// Параметры:
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  Представление           - Строка - представление элемента компоновки данных.
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//
Функция ИзменитьЭлементыОтбора(ОбластьПоиска,
								Знач ИмяПоля = Неопределено,
								Знач Представление = Неопределено,
								Знач ПравоеЗначение = Неопределено,
								Знач ВидСравнения = Неопределено,
								Знач Использование = Неопределено,
								Знач РежимОтображения = Неопределено,
								Знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ИмяПоля) Тогда
		ЗначениеПоиска = Новый ПолеКомпоновкиДанных(ИмяПоля);
		СпособПоиска = 1;
	Иначе
		СпособПоиска = 2;
		ЗначениеПоиска = Представление;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	НайтиРекурсивно(ОбластьПоиска.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
	
	Для Каждого Элемент Из МассивЭлементов Цикл
		Если ИмяПоля <> Неопределено Тогда
			Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
		КонецЕсли;
		Если Представление <> Неопределено Тогда
			Элемент.Представление = Представление;
		КонецЕсли;
		Если Использование <> Неопределено Тогда
			Элемент.Использование = Использование;
		КонецЕсли;
		Если ВидСравнения <> Неопределено Тогда
			Элемент.ВидСравнения = ВидСравнения;
		КонецЕсли;
		Если ПравоеЗначение <> Неопределено Тогда
			Элемент.ПравоеЗначение = ПравоеЗначение;
		КонецЕсли;
		Если РежимОтображения <> Неопределено Тогда
			Элемент.РежимОтображения = РежимОтображения;
		КонецЕсли;
		Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
			Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивЭлементов.Количество();
	
КонецФункции

// Выполняет рекурсивный поиск.
//
Процедура НайтиРекурсивно(КоллекцияЭлементов, МассивЭлементов, СпособПоиска, ЗначениеПоиска)
	
	Для каждого ЭлементОтбора Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			Если СпособПоиска = 1 Тогда
				Если ЭлементОтбора.ЛевоеЗначение = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			ИначеЕсли СпособПоиска = 2 Тогда
				Если ЭлементОтбора.Представление = ЗначениеПоиска Тогда
					МассивЭлементов.Добавить(ЭлементОтбора);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			НайтиРекурсивно(ЭлементОтбора.Элементы, МассивЭлементов, СпособПоиска, ЗначениеПоиска);
			
			Если СпособПоиска = 2 И ЭлементОтбора.Представление = ЗначениеПоиска Тогда
				МассивЭлементов.Добавить(ЭлементОтбора);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьСвойствоЭлементовФормы(Форма, Элементы, ИмяСвойства, Значение) Экспорт
	
	Если ТипЗнч(Элементы) = Тип("Строка") Тогда
		МассивЭлементов = РазложитьСтрокуВМассивПодстрок(Элементы,,,Истина);
	ИначеЕсли ТипЗнч(Элементы) = Тип("Массив") Тогда
		МассивЭлементов = Элементы;
	Иначе
		Возврат;
	КонецЕсли;
	
	ЭлементыФормы = Форма.Элементы;
	
	Для Каждого ИмяЭлемента Из МассивЭлементов Цикл
		
		Если НЕ ЭлементыФормы[ИмяЭлемента][ИмяСвойства] = Значение Тогда
			ЭлементыФормы[ИмяЭлемента][ИмяСвойства] = Значение;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Добавить элемент компоновки в контейнер элементов компоновки.
//
// Параметры:
//  ОбластьДобавления - контейнер с элементами и группами отбора, например.
//                  Список.Отбор или группа в отборе.
//  ИмяПоля                 - Строка - имя поля компоновки данных (заполняется всегда).
//  ПравоеЗначение          - произвольный - сравниваемое значение.
//  ВидСравнения            - ВидСравненияКомпоновкиДанных - вид сравнения.
//  Представление           - Строка - представление элемента компоновки данных.
//  Использование           - Булево - использование элемента.
//  РежимОтображения        - РежимОтображенияЭлементаНастройкиКомпоновкиДанных - режим отображения.
//  ИдентификаторПользовательскойНастройки - Строка - см. ОтборКомпоновкиДанных.ИдентификаторПользовательскойНастройки
//                                                    в синтакс-помощнике.
//
Функция ДобавитьЭлементКомпоновкиСИдентификатором(ОбластьДобавления,
									Знач ИмяПоля,
									Знач ВидСравнения,
									Знач ПравоеЗначение = Неопределено,
									Знач Представление  = Неопределено,
									Знач Использование  = Неопределено,
									знач РежимОтображения = Неопределено,
									знач ИдентификаторПользовательскойНастройки = Неопределено) Экспорт
	
	Элемент = ОбластьДобавления.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	Элемент.ВидСравнения = ВидСравнения;
	
	Если РежимОтображения = Неопределено Тогда
		Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Иначе
		Элемент.РежимОтображения = РежимОтображения;
	КонецЕсли;
	
	Если ПравоеЗначение <> Неопределено Тогда
		Элемент.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
	Если Представление <> Неопределено Тогда
		Элемент.Представление = Представление;
	КонецЕсли;
	
	Если Использование <> Неопределено Тогда
		Элемент.Использование = Использование;
	КонецЕсли;
	
	// Важно: установка идентификатора должна выполняться
	// в конце настройки элемента, иначе он будет скопирован
	// в пользовательские настройки частично заполненным.
	Если ИдентификаторПользовательскойНастройки <> Неопределено Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
	ИначеЕсли Элемент.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
		Элемент.ИдентификаторПользовательскойНастройки = ИмяПоля;
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Результат = Новый Массив;
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции 

// Устанавливает указанное значение у указанной константы.
//
// Параметры:
//  ИмяКонстанты      - Строка - Имя константы;
//  ЗначениеКонстанты - Произвольный - Устанавливаемое значение константы..
//
Процедура УстановитьЗначениеКонстанты(ИмяКонстанты, ЗначениеКонстанты) Экспорт

	Константы[ИмяКонстанты].Установить(ЗначениеКонстанты);

КонецПроцедуры

// Возвращает значение указанной константы.
//
// Параметры:
//  ИмяКонстанты - Строка - Имя константы.
// 
// Возвращаемое значение:
//  Произвольный - Значение константы.
//
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт

	Возврат Константы[ИмяКонстанты].Получить();

КонецФункции

Процедура УдалитьСтарыеФото() Экспорт

	КоличествоДнейХраненияФото = Константы.КоличествоДнейХраненияФото.Получить();	
	КаталогФото = Константы.КаталогФото.Получить();
	
	Если КоличествоДнейХраненияФото = 0 Тогда
		Возврат;
	КонецЕсли;

	МассивФайлов = НайтиФайлы(КаталогФото, "*.jpg", Ложь);
	
//	Запрос = Новый Запрос("ВЫБРАТЬ
//	|	Фото.Ссылка,
//	|	Фото.АдресНаДиске
//	|ИЗ
//	|	РегистрСведений.ОчередьФотоНаСервер КАК ОчередьФотоНаСервер
//	|		ПРАВОЕ СОЕДИНЕНИЕ Документ.ОФ_ОценкаКачестваУборкиУрожая.Фото КАК Фото
//	|		ПО Фото.Ссылка = ОчередьФотоНаСервер.Документ
//	|		И Фото.ИндексФото = ОчередьФотоНаСервер.ИндексФото
//	|где
//	|	Фото.Ссылка.Дата < &Период
//	|	И ОчередьФотоНаСервер.Документ is null");	
//
//	Запрос.УстановитьПараметр("Период", НачалоДня(ТекущаяДата()) - КоличествоДнейХраненияФото * 86400);
//	
//	Выборка = Запрос.Выполнить().Выбрать();
//	Пока Выборка.Следующий() Цикл
//		ФайлФото = Новый Файл(Выборка.АдресНаДиске);
//		Если ФайлФото.Существует() Тогда
//			Попытка
//				УдалитьФайлы(Выборка.АдресНаДиске);
//			Исключение
//				Сообщить(ОписаниеОшибки());	
//			КонецПопытки;
//		КонецЕсли;		
//	КонецЦикла;
		
КонецПроцедуры
