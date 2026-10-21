#include <cuda_runtime.h>

__global__ void invert_kernel(unsigned char* image, int width, int height) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < (width * height)) {
        int baseIdx = idx * 4;
        image[baseIdx + 0] = 255 - image[baseIdx + 0];
        image[baseIdx + 1] = 255 - image[baseIdx + 1];
        image[baseIdx + 2] = 255 - image[baseIdx + 2];
    }


}
// image is a device pointer (i.e. pointer to memory on the GPU)
extern "C" void solve(unsigned char* image, int width, int height) {
    int threadsPerBlock = 256;
    int blocksPerGrid = ((width * height) + threadsPerBlock - 1) / threadsPerBlock;

    invert_kernel<<<blocksPerGrid, threadsPerBlock>>>(image, width, height);
    cudaDeviceSynchronize();
}