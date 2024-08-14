#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

__global__ void addKernel(int *d_d, const int *d_a, const int *d_b, const int *d_c){
    int i = threadIdx.x;
    d_d[i] = d_a[i] + d_b[i] + d_c[i];
}

int main(void){
    const int SIZE = 5;
    int a[SIZE], b[SIZE], c[SIZE], d[SIZE];
    int *d_a, *d_b, *d_c, *d_d;
    
    srand((unsigned int)time(NULL));
    for(int i = 0; i < SIZE; i++){
        a[i] = rand() % 100;
        b[i] = rand() % 100;
        c[i] = rand() % 100;
    }

    cudaMalloc(&d_a, SIZE * sizeof(int));
    cudaMalloc(&d_b, SIZE * sizeof(int));
    cudaMalloc(&d_c, SIZE * sizeof(int));
    cudaMalloc(&d_d, SIZE * sizeof(int));
    
    cudaMemcpy(d_a, a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, SIZE * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_c, c, SIZE * sizeof(int), cudaMemcpyHostToDevice);
    
    addKernel<<< 1, SIZE >>> (d_d, d_a, d_b, d_c);

    cudaMemcpy(d, d_d, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

    cudaDeviceSynchronize();
    for(int i = 0; i < SIZE; i++)
        cout << i << " : " << a[i] << " + "  << b[i] << " + " << c[i] << " = " << d[i] << endl;

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFree(d_d);

    return 0;
}