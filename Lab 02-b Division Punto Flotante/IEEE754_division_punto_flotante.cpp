#include <iostream>
#include <bitset>
//#include <stdint.h>
using namespace std;

union Float32 
{
    float f;
    uint32_t i;
};

int extraerSigno(uint32_t bits) 
{
    return (bits >> 31) & 1;
}

int extraerExponente(uint32_t bits) 
{
    return (bits >> 23) & 0xFF;
}

uint32_t extraerMantisa(uint32_t bits) 
{
    return bits & 0x7FFFFF;
}

void mostrarBits(uint32_t bits)
{
    bitset<32> b(bits);
    cout << "Bits: " << b << endl;
    cout << " Signo     : " << b[31] << endl;
    cout << " Exponente : " << b.to_string().substr(1, 8) << endl;
    cout << " Mantisa   : " << b.to_string().substr(9) << endl;
}
uint32_t dividirMantisas(uint64_t dividendo, uint32_t divisor) 
{
    uint64_t cociente = 0;
    int shift = 0;

    
    while ((divisor << shift) <= dividendo && shift < 64) 
    {
        shift++;
    }

    while (shift > 0) 
    {
        shift--;
        if ((uint64_t(divisor) << shift) <= dividendo)
        {
            dividendo -= (uint64_t(divisor) << shift);
            cociente |= (1ULL << shift);
        }
    }

    return static_cast<uint32_t>(cociente);
}

float dividirPuntoFlotante(float dividendo, float divisor)
{
   
    Float32 a, b, resultado;
    a.f = dividendo;
    b.f = divisor;

    int signoA = extraerSigno(a.i);
    int signoB = extraerSigno(b.i);
    int signoR = signoA ^ signoB; 

    int expA = extraerExponente(a.i);
    int expB = extraerExponente(b.i);

    uint32_t mantisaA = extraerMantisa(a.i) | 0x800000;  
    uint32_t mantisaB = extraerMantisa(b.i) | 0x800000;  

    // numeros especiales
    // infinito o NaN
    if (expA == 0xFF || expB == 0xFF)
    {
        return (signoR == 0) ? INFINITY : -INFINITY;
    }

    // division por cero
    if (expB == 0 && mantisaB == 0x800000)
    {
        return (signoR == 0) ? INFINITY : -INFINITY;
    }

    //  calcular exponente preliminar
    int expR = expA - expB + 127;

    //  division de mantisas
    uint64_t divMantisaA = static_cast<uint64_t>(mantisaA) << 23;  

    //uint32_t cociente = divMantisaA / mantisaB;

    uint32_t cociente = dividirMantisas(divMantisaA, mantisaB);
    //  normalizacion
    
    if (cociente >= 0x1000000)
    {
        while (cociente >= 0x1000000)
        {
            cociente >>= 1;
            expR++;
        }
    }
   
    else if (cociente < 0x800000)
    {
        while (cociente < 0x800000 && expR > 0)
        {
            cociente <<= 1;
            expR--;
        }
    }

    // overflow
    if (expR >= 255) 
    {
        
        resultado.i = (signoR << 31) | 0x7F800000;  // infinito 
        return resultado.f;
    }
    // underflow
    if (expR <= 0) 
    {
        resultado.i = signoR << 31;  // cero 
        return resultado.f;
    }

    // quitar el bit 1
    uint32_t mantisaR = cociente & 0x7FFFFF;

    
    resultado.i = (signoR << 31) | (expR << 23) | mantisaR;
    return resultado.f;
}

int main() 
{
    float a, b;
    cout << "Ingrese el primer numero (dividendo): ";
    cin >> a;

    cout << endl;
    cout << "Ingrese el segundo numero (divisor): ";
    cin >> b;


    cout << endl;
    Float32 valorA, valorB;
    valorA.f = a;
    valorB.f = b;

    cout << "A:" << endl;
    mostrarBits(valorA.i);

    cout << endl;
    cout << "B:" << endl;
    mostrarBits(valorB.i);

    
    float resultado = dividirPuntoFlotante(a, b);

    cout << endl;
    
    Float32 resVal;
    resVal.f = resultado;
    cout << "Resultado Simulado:" << endl;
    mostrarBits(resVal.i);

    cout << endl;
    cout << "Resultado float: " << resultado << endl;

    cout << endl;
    float esperado = a / b;
    Float32 esp;
    esp.f = esperado;
    cout << "Resultado C++ " << endl;
    mostrarBits(esp.i);
    cout << "Esperado  " << esperado << endl;

    return 0;
}