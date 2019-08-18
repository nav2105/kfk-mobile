
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ДобавитьСообщение(ЗаписьJSON) Экспорт
	
	//ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайлаСообщенияОбмена);
	ДанныеОбмена = Новый ХранилищеЗначения(ЗаписьJSON.Закрыть(), Новый СжатиеДанных(9));

	НовыйЭлементОчереди = РегистрыСведений.ОчередьСообщенийНаСервер.СоздатьМенеджерЗаписи();

	НовыйЭлементОчереди.Данные        = ДанныеОбмена;
	НовыйЭлементОчереди.МоментВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
	НовыйЭлементОчереди.Идентификатор = Новый УникальныйИдентификатор();

	НовыйЭлементОчереди.Записать();
	
КонецПроцедуры

// Удаляет указанное сообщение из очереди 
//
// Параметры:
//  Идентификатор - УникальныйИдентификатор - Идентификатор сообщения.
//
Процедура УдалитьСообщение(Идентификатор) Экспорт

	НаборЗаписей = РегистрыСведений.ОчередьСообщенийНаСервер.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Идентификатор.Установить(Идентификатор);
	НаборЗаписей.Записать();

	Выборка = РегистрыСведений.ОчередьСообщенийНаСервер.Выбрать();
	Если Выборка.Следующий() Тогда
		Константы.ЕстьНеотправленныеДанные.Установить(Истина);
	Иначе
		Константы.ЕстьНеотправленныеДанные.Установить(Ложь)		
	КонецЕсли;

КонецПроцедуры

// Очищает очередь сообщений подготовленных для сервера
//
Процедура ОчиститьОчередьСообщенияДляСервера() Экспорт

	Выборка = РегистрыСведений.ОчередьСообщенийНаСервер.Выбрать();

	Пока Выборка.Следующий() Цикл

		УдалитьСообщение(Выборка.Идентификатор);

	КонецЦикла;

КонецПроцедуры

// Возвращает количество сообщений готовых к отправке на сервер
// 
// Возвращаемое значение:
//  Счетчик - Число сообщений в очереди.
//
Функция КоличествоСообщенийВОчереди() Экспорт

	Счетчик = 0;
	Выборка = РегистрыСведений.ОчередьСообщенийНаСервер.Выбрать();

	Пока Выборка.Следующий() Цикл
		Счетчик = Счетчик + 1;
	КонецЦикла;

	Возврат Счетчик;

КонецФункции

Функция МассивСообщений() Экспорт
	
	МассивСообщения = Новый Массив;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОчередьСообщенийНаСервер.Данные КАК Данные,
	                      |	ОчередьСообщенийНаСервер.Идентификатор КАК Идентификатор
	                      |ИЗ
	                      |	РегистрСведений.ОчередьСообщенийНаСервер КАК ОчередьСообщенийНаСервер
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ОчередьСообщенийНаСервер.МоментВремени");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		СтруктураСообщения = Новый Структура("Данные, Идентификатор", Выборка.Данные.Получить(), Выборка.Идентификатор);  
		МассивСообщения.Добавить(СтруктураСообщения);	
	КонецЦикла;
	
	Возврат МассивСообщения;
	
КонецФункции

#КонецОбласти

#КонецЕсли

