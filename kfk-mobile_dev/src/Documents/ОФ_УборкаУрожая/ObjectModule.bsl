
Процедура ПриКопировании(ОбъектКопирования)
	
	Контейнеры.Очистить();
	Автор = Константы.ПользовательЦентральнойБазы.Получить();
	ИтогоКонтейнеров = 0;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Автор = Константы.ПользовательЦентральнойБазы.Получить();

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	ИтогоКонтейнеров = Контейнеры.Количество();
	
КонецПроцедуры
