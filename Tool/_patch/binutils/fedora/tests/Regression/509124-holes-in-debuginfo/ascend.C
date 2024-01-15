class A { 
public: 
  A(); 
  void f(){} 
};

class C { 
  C(); 
};

C::C() {
  A* p = new A; 
  p->f();
}

