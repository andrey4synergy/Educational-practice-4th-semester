/**
 * Модуль тестирования функций работы с датами
 * Запуск в браузере: подключите этот файл после script.js и вызовите runAllTests()
 */

const dateCalc = (function() {
    return window; // Обертка
})();


const TEST_CONFIG = {
    colors: {
        success: '\x1b[32m', // Зеленый
        fail: '\x1b[31m',    // Красный
        reset: '\x1b[0m'     // Сброс
    },
    maxDescriptionLength: 50
};

/**
 * Утилита для тестирования
 * @param {string} description Описание теста
 * @param {function} testFn Функция, содержащая assert-проверки
 */
function test(description, testFn) {
    try {
        testFn();
        console.log(`${TEST_CONFIG.colors.success}+ ${description.padEnd(TEST_CONFIG.maxDescriptionLength)} ${TEST_CONFIG.colors.reset}`);
    } catch (error) {
        console.error(`${TEST_CONFIG.colors.fail}- ${description.padEnd(TEST_CONFIG.maxDescriptionLength)} ${TEST_CONFIG.colors.reset}`);
        console.error(`  ${error.message}`);
        if (error.expected !== undefined) {
            console.error(`  Ожидалось: ${error.expected}`);
            console.error(`  Получено: ${error.actual}`);
        }
    }
}

/**
 * Assert: проверка равенства
 * @param {*} actual Фактическое значение
 * @param {*} expected Ожидаемое значение
 * @param {string} message Сообщение об ошибке
 */
function assertEqual(actual, expected, message = '') {
    if (actual !== expected && JSON.stringify(actual) !== JSON.stringify(expected)) {
        const error = new Error(message);
        error.actual = actual;
        error.expected = expected;
        throw error;
    }
}

/**
 * Assert: проверка на ошибку
 * @param {function} fn Функция, которая должна выбросить ошибку
 * @param {string} expectedError Ожидаемое сообщение ошибки
 */
function assertThrows(fn, expectedError) {
    try {
        fn();
        throw new Error(`Ожидалась ошибка "${expectedError}", но функция выполнилась успешно`);
    } catch (error) {
        if (error.message !== expectedError) {
            throw new Error(`Ожидалась ошибка "${expectedError}", но получено: "${error.message}"`);
        }
    }
}

// Тесты на основные функции script.js

function testIsLeapYear() {
    test('2024 - високосный год', () => {
        assertEqual(dateCalc.isLeapYear(2024), true);
    });

    test('2023 - не високосный год', () => {
        assertEqual(dateCalc.isLeapYear(2023), false);
    });

    test('2000 - високосный (кратен 400)', () => {
        assertEqual(dateCalc.isLeapYear(2000), true);
    });

    test('1900 - не високосный (кратен 100)', () => {
        assertEqual(dateCalc.isLeapYear(1900), false);
    });
}

function testParseDate() {
    test('Корректный парсинг даты "15.06.2025"', () => {
        assertEqual(dateCalc.parseDate('15.06.2025'), [15, 6, 2025]);
    });

    test('Парсинг даты с пробелами', () => {
        assertEqual(dateCalc.parseDate('  01.01.2024  '), [1, 1, 2024]);
    });

    test('Некорректный формат (дд-мм-гггг)', () => {
        assertThrows(() => dateCalc.parseDate('31-12-2023'), 'Неверный формат даты');
    });

    test('Нечисловые символы в дате', () => {
        assertThrows(() => dateCalc.parseDate('ab.cd.efgh'), 'Неверный формат даты');
    });
}

function testDateValidation() {
    test('Корректная дата 31.12.2023', () => {
        const date = new Date(2023, 11, 31);
        assertEqual(dateCalc.isDateValid(date, 31, 12, 2023), true);
    });

    test('30.02.2023 - некорректная дата', () => {
        const date = new Date(2023, 1, 30);
        assertEqual(dateCalc.isDateValid(date, 30, 2, 2023), false);
    });

    test('29.02.2024 - корректная (високосный)', () => {
        const date = new Date(2024, 1, 29);
        assertEqual(dateCalc.isDateValid(date, 29, 2, 2024), true);
    });

    test('Год меньше 1900 - невалидный', () => {
        const date = new Date(1899, 11, 31);
        assertEqual(dateCalc.isDateValid(date, 31, 12, 1899), false);
    });
}

function testDaysCalculation() {
    test('01.01.2023 → 364 дня', () => {
        const date = new Date(2023, 0, 1);
        assertEqual(dateCalc.calculateDaysUntilNewYear(date), 364);
    });

    test('31.12.2023 → 0 дней', () => {
        const date = new Date(2023, 11, 31);
        assertEqual(dateCalc.calculateDaysUntilNewYear(date), 0);
    });

    test('30.12.2023 → 1 день', () => {
        const date = new Date(2023, 11, 30);
        assertEqual(dateCalc.calculateDaysUntilNewYear(date), 1);
    });

    test('01.01.2024 → 365 дней (високосный)', () => {
        const date = new Date(2024, 0, 1);
        assertEqual(dateCalc.calculateDaysUntilNewYear(date), 365);
    });
}

function testCreateValidDate() {
    test('Создание валидной даты 15.06.2025', () => {
        const date = dateCalc.createValidDate(2025, 6, 15);
        assertEqual(date.getFullYear(), 2025);
        assertEqual(date.getMonth(), 5); // Месяцы 0-11
    });

    test('Попытка создать 31.04.2023 - ошибка', () => {
        assertThrows(
            () => dateCalc.createValidDate(2023, 4, 31),
            'Некорректная дата'
        );
    });

    test('Попытка создать 29.02.2023 - ошибка', () => {
        assertThrows(
            () => dateCalc.createValidDate(2023, 2, 29),
            'Некорректная дата'
        );
    });
}

// Запуск всех тестов
function runAllTests() {
    console.log('\nТесты isLeapYear():');
    testIsLeapYear();
    
    console.log('\nТесты parseDate():');
    testParseDate();
    
    console.log('\nТесты isDateValid():');
    testDateValidation();
    
    console.log('\nТесты calculateDaysUntilNewYear():');
    testDaysCalculation();
    
    console.log('\nТесты createValidDate():');
    testCreateValidDate();
}
