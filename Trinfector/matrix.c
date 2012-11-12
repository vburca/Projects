#include <stdio.h>
#include <time.h>

main(){
  int x, i;
  time_t start, end;
  int reps = 1000;
  unsigned int size = reps * 1000;
  start = time(NULL);
  printf("\n");
  for (i = 0; i < size; i++){
    x = (rand() % 100)%2;
    printf("%d ", x);
    if (i % 80 == 0)
      printf("\n");
  }
  printf("\n");
  end = time(NULL) - start;
  printf("The algorithm took %ld seconds.\n", end);
}
