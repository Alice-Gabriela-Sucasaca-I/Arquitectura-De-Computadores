#include <iostream>
#include <string>
#include <bitset>

using namespace std;

string convertirABinario(int num, int n)
{
    if (num >= 0)
    {
        string res = bitset<32>(num).to_string();
        return res.substr(32 - n);
    }
    else
    {
        int positivo = (1 << n) + num;
        string res = bitset<32>(positivo).to_string();
        return res.substr(32 - n);
    }
}

string sumaBinaria(string a, string b, int n)
{
    string resultado(n, '0');
    int carry = 0;
    for (int i = n - 1; i >= 0; i--)
    {
        int bitA = a[i] - '0';
        int bitB = b[i] - '0';
        int suma = bitA + bitB + carry;
        resultado[i] = (suma % 2) + '0';
        carry = suma / 2;
    }
    return resultado;
}

string complementoA2(string bin)
{
    int n = bin.length();
    string invertido = bin;
    for (int i = 0; i < n; i++)
        invertido[i] = (bin[i] == '0') ? '1' : '0';
    string uno(n, '0');
    uno[n - 1] = '1';
    return sumaBinaria(invertido, uno, n);
}

void desplazamientoDerecha(string& A, string& Q, char& Q_1)
{
    char ultimoA = A[0];
    Q_1 = Q.back();

    Q = A.back() + Q.substr(0, Q.length() - 1);
    A = ultimoA + A.substr(0, A.length() - 1);
}

int convertirADecimal(string bin)
{
    int n = bin.size();
    if (bin[0] == '0')
    {
        return stoi(bin, nullptr, 2);
    }
    else
    {
        string comp2 = complementoA2(bin);
        return -1 * stoi(comp2, nullptr, 2);
    }
}

int main()
{
    int multiplicando, multiplicador, n;
    cout << "Ingrese numero de bits: ";
    cin >> n;

    cout << "Ingrese el multiplicando (M): ";
    cin >> multiplicando;

    cout << "Ingrese el multiplicador (Q): ";
    cin >> multiplicador;

    string A(n, '0');
    string Q = convertirABinario(multiplicador, n);
    string M = convertirABinario(multiplicando, n);
    string M_neg = complementoA2(M);

    char Q_1 = '0';

    cout << "\n--- Estado inicial ---\n";
    cout << "A: " << A << " | Q: " << Q << " | Q-1: " << Q_1 << endl;

    for (int i = 0; i < n; i++) {
        cout << "\n--- Ciclo " << i + 1 << " ---\n";
        string operacion = "Ninguna";

        if (Q.back() == '1' && Q_1 == '0') {
            A = sumaBinaria(A, M_neg, n);
            operacion = "A = A - M";
        }
        else if (Q.back() == '0' && Q_1 == '1') {
            A = sumaBinaria(A, M, n);
            operacion = "A = A + M";
        }

        cout << operacion << endl;

        desplazamientoDerecha(A, Q, Q_1);

        cout << "A: " << A << " | Q: " << Q << " | Q-1: " << Q_1 << endl;
    }

    string resultadoBin = A + Q;
    int resultadoDecimal = convertirADecimal(resultadoBin);

    cout << "\nResultado binario: " << resultadoBin << endl;
    cout << "Resultado decimal: " << resultadoDecimal << endl;

    return 0;
}