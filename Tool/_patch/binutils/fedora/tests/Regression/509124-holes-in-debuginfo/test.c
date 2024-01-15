void f(int i) {
  k(i);
}

void g(int i) {
  int j[65537]; 
  l(i,j);
}

struct s {
  void (*m)(int i); 
  void (*n)(int i);
} t={f,g};

