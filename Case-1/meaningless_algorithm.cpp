#include <iostream>
#include <vector>
#include <limits>

using namespace std;

int main() {
    int N;
    double B;

    // В реализации на плюсах обработка ошибок будет завершением с кодом ошибки.
    cout << "Введите размерность массива N: ";
    if (!(cin >> N)) {
        cerr << "Ошибка: Некорректный ввод для N. Ожидалось целое число." << endl;
        return 1;
    }
    if (N <= 0) {
        cerr << "Ошибка: Размерность массива N должна быть положительным числом." << endl;
        return 1;
    }

    cout << "Введите число B: ";
    if (!(cin >> B)) {
        cerr << "Ошибка: Некорректный ввод для B. Ожидалось число." << endl;
        return 1;
    }

    vector<double> A(N);

    cout << "Введите " << N << " элементов массива A:" << endl;
    for (int i = 0; i < N; ++i) {
        cout << "A[" << i << "]: ";
        if (!(cin >> A[i])) {
            cerr << "Ошибка: Некорректный ввод для элемента A[" << i << "]. Ожидалось число." << endl;
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            return 1;
        }
        if (!isfinite(A[i])) {
            cerr << "Ошибка: Введено недопустимое значение для A[" << i << "] (NaN, Inf)." << endl;
            return 1;
        }
    }

    double sum_positive = 0.0;
    int count_positive = 0;
    int count_greater_than_B = 0;
    double product_greater_than_B = 1.0;
    bool found_greater = false;

    for (int i = 0; i < N; ++i) {
        // Сумма и количество положительных элементов
        if (A[i] > 0) {
            sum_positive += A[i];
            count_positive++;
        }

        // Количество и произведение элементов > B
        if (A[i] > B) {
            count_greater_than_B++;
            product_greater_than_B *= A[i];
            found_greater = true;
        }
    }

    cout << "\n--- Результаты ---" << endl;
    cout << "Сумма положительных элементов: " << sum_positive << endl;
    cout << "Количество положительных элементов: " << count_positive << endl;

    cout << "Количество элементов, больших " << B << ": " << count_greater_than_B << endl;

    if (found_greater) {
        cout << "Произведение элементов, больших " << B << ": " << product_greater_than_B << endl;
    } else {
        cout << "Произведение элементов, больших " << B << "элементов не найдено" << endl;
    }

    return 0;
}