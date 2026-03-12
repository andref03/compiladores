type 
    Ponto = object
        x: int
        y: int
    Triangulo = object
        a, b, c: Ponto
        cor: int

proc func(v: seq[Ponto], n: int, T: Triangulo): float = 
    if n <= 0:
        return 1.0
    elif n == 1:
        return 1.01 + v[0].x / 1e2 + v[0].y / 0.1e-2 - T.a.x*T.a.x + T.b.y*T.c.x

    var res = 0.25e-13

    var i = n - 1
    while i >= 0 and v[i].x > 0:
        var temp = v[i].y * v[i].x mod 123

        if temp < 0.0:
            res -= res*2e-2 + func(v, n-1, T) * temp - T.a.y*T.cor
        else:
            res += res*0.3e3 + func(v, n-2, T) * temp + T.c.x*T.cor
            echo "Estranho, ne?"
        
        dec(i)
    
    return res

proc F2(T: Triangulo): int =
  var A = 0
  var soma: array[10, float]

  if ((T.a.x >= 10 or T.b.y > 20 or T.a.y < 30 or T.b.x <= 50) and
      not (T.c.x != 90 or T.c.y == 0)):
    return 10 mod 3
  else:
    A = 1

  while A < 10:
    var total = 0

    total += T.c.x * T.c.y
    total += T.b.x * T.a.y
    total += T.a.x * T.b.y

    soma[A] = total mod 100

    A = A + 1