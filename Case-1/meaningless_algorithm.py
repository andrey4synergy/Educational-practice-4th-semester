def main():
    try:
        N = int(input("Введите размерность массива N: "))
        if N <= 0:
             print("Размерность массива должна быть положительным числом.")
             return
        B = float(input("Введите число B: "))
    except ValueError:
        print("Ошибка ввода. Пожалуйста, введите числовые значения.")
        return

    A = []
    print(f"Введите {N} элементов массива A:")
    for i in range(N):
        try:
            element = float(input(f"A[{i}]: "))
            A.append(element)
        except ValueError:
            print("Ошибка ввода. Пожалуйста, введите числовое значение.")
            return

    sum_positive = 0.0
    count_positive = 0
    count_greater_than_b = 0
    product_greater_than_b = 1.0

    found_greater = False # Были ли элементы > B?

    for i in range(N):
        if A[i] > 0:
            sum_positive += A[i]
            count_positive += 1

        if A[i] > B:
            count_greater_than_b += 1
            product_greater_than_b *= A[i]
            found_greater = True

    print("\n--- Результаты ---")
    print(f"Сумма положительных элементов: {sum_positive}")
    print(f"Количество положительных элементов: {count_positive}")

    print(f"Количество элементов, больших {B}: {count_greater_than_b}")
    if found_greater:
        print(f"Произведение элементов, больших {B}: {product_greater_than_b}")
    else:
        print(f"Произведение элементов, больших {B}: элементов не найдено")

if __name__ == "__main__":
    main()