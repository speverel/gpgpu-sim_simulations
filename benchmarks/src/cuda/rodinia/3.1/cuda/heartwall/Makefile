
ifdef OUTPUT
override OUTPUT = -DOUTPUT
endif

# link objects(binaries) together
heartwall: main.o ./AVI/avilib.o ./AVI/avimod.o 
	g++ main.o -fPIC  -m64  -L/home/vkz4947/cuda-9.1/lib64 -L../../common/lib/linux  -lcudart ./AVI/avilib.o ./AVI/avimod.o -lm -o heartwall

# compile main function file into object (binary)
main.o: main.cu kernel.cu define.c
	nvcc $(OUTPUT) $(KERNEL_DIM) -gencode arch=compute_70,code=sm_70 -gencode arch=compute_70,code=compute_70 main.cu -I./AVI -c 

./AVI/avilib.o ./AVI/avimod.o:
	cd AVI; make;

# delete all object files
clean:
	rm -f *.o AVI/*.o heartwall *.linkinfo
