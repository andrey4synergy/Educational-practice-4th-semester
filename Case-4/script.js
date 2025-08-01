/**
 * Модуль для работы с датами
 * @module dateCalculator
 */

// Константы
const DECEMBER_MONTH_INDEX = 11;
const FEBRUARY_MONTH_INDEX = 1;
const DAYS_IN_FEBRUARY_LEAP = 29;
const DAYS_IN_FEBRUARY_COMMON = 28;
const MIN_YEAR = 1900;
const MAX_YEAR = 2100;

// Кэш для високосных годов (мемоизация)
const leapYearCache = {};

/**
 * Проверяет, является ли год високосным
 * @param {number} year Год для проверки
 * @returns {boolean} true если год високосный
 */
function isLeapYear(year) {
    if (leapYearCache[year] !== undefined) return leapYearCache[year];
    
    const isLeap = (year % 400 === 0) || (year % 100 !== 0 && year % 4 === 0);
    leapYearCache[year] = isLeap;
    return isLeap;
}

/**
 * Проверяет валидность даты
 * @param {Date} date Объект Date
 * @param {number} day День
 * @param {number} month Месяц
 * @param {number} year Год
 * @returns {boolean} true если дата валидна
 */
function isDateValid(date, day, month, year) {
    if (isNaN(date.getTime())) return false;
    if (year < MIN_YEAR || year > MAX_YEAR) return false;
    
    // Проверка февраля
    if (month - 1 === FEBRUARY_MONTH_INDEX) {
        const maxDays = isLeapYear(year) ? DAYS_IN_FEBRUARY_LEAP : DAYS_IN_FEBRUARY_COMMON;
        if (day > maxDays) return false;
    }
    
    return (
        date.getDate() === day &&
        date.getMonth() === month - 1 &&
        date.getFullYear() === year
    );
}

/**
 * Парсит строку даты в формате дд.мм.гггг
 * @param {string} dateStr Строка с датой
 * @returns {[number, number, number]} Массив [день, месяц, год]
 * @throws {Error} Если формат неверный
 */
function parseDate(dateStr) {
    const cleanInput = dateStr.trim();
    if (!/^\d{2}\.\d{2}\.\d{4}$/.test(cleanInput)) {
        throw new Error('Неверный формат даты');
    }
    
    const [day, month, year] = cleanInput.split('.').map(Number);
    return [day, month, year];
}

/**
 * Создает объект Date с валидацией
 * @param {number} year Год
 * @param {number} month Месяц (1-12)
 * @param {number} day День
 * @returns {Date} Объект Date
 * @throws {Error} Если дата невалидна
 */
function createValidDate(year, month, day) {
    const date = new Date(year, month - 1, day);
    if (!isDateValid(date, day, month, year)) {
        throw new Error('Некорректная дата');
    }
    return date;
}

/**
 * Вычисляет количество дней до Нового года
 * @param {Date} date Начальная дата
 * @returns {number} Количество дней
 */
function calculateDaysUntilNewYear(date) {
    const currentYear = date.getFullYear();
    const newYearDate = new Date(currentYear, DECEMBER_MONTH_INDEX, 31);
    const diffTime = newYearDate - date;
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
}

/**
 * Отображает ошибку в интерфейсе
 * @param {HTMLElement} element Элемент для вывода ошибки
 * @param {string} message Текст ошибки
 */
function showError(element, message) {
    element.textContent = message;
    element.classList.add('error');
}

/**
 * Очищает результаты
 * @param {HTMLElement[]} elements Элементы для очистки
 */
function clearResults(...elements) {
    elements.forEach(el => {
        el.textContent = '';
        el.classList.remove('error');
    });
}

/**
 * Основная функция обработки
 */
function handleCalculateClick() {
    const dateInput = document.getElementById('dateInput');
    const daysResult = document.getElementById('daysResult');
    const leapYearResult = document.getElementById('leapYearResult');
    
    clearResults(daysResult, leapYearResult);
    
    try {
        const [day, month, year] = parseDate(dateInput.value);
        const inputDate = createValidDate(year, month, day);
        
        const daysLeft = calculateDaysUntilNewYear(inputDate);
        daysResult.textContent = `До Нового года осталось: ${daysLeft} дней`;
        
        const isLeap = isLeapYear(year);
        leapYearResult.textContent = isLeap ? 'Високосный год' : 'Не високосный год';
        
    } catch (error) {
        showError(daysResult, error.message);
    }
}

// Инициализация
document.addEventListener('DOMContentLoaded', () => {
    const calculateBtn = document.getElementById('calculateBtn');
    calculateBtn.addEventListener('click', handleCalculateClick);
    
    // Добавляем подсказку при фокусе
    const dateInput = document.getElementById('dateInput');
    dateInput.addEventListener('focus', () => {
        dateInput.placeholder = 'Например: 15.06.2023';
    });
    dateInput.addEventListener('blur', () => {
        dateInput.placeholder = 'дд.мм.гггг';
    });
});

// Экспорт для тестов
// TODO: удалить проверку
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        isLeapYear,
        parseDate,
        isDateValid,
        createValidDate,
        calculateDaysUntilNewYear,
        showError,
        clearResults
    };
}