type
  Ponto = object
    x: int
    y: int

  Triangulo = object
    a: Ponto
    b: Ponto
    c: Ponto
    cor: int

proc func(n: int, T: Triangulo): float =
  if n <= 0:
    return 1.0
  elif n == 1:
    return 1.01 + T.a.x / 1e2 + T.a.y / 0.1e-2 - T.a.x * T.a.x + T.b.y * T.c.x

  var res = 0.25e-13

  var i = n - 1
  while i >= 0 and T.a.x > 0:
    let temp = (T.a.y * T.a.x) mod 123

    if temp < 0.0:
      res = res - res * 2e-2 + func(n - 1, T) * temp - T.a.y * T.cor
    else:
      res = res + res * 0.3e3 + func(n - 2, T) * temp + T.c.x * T.cor

    i = i - 1

  return res

proc f2A(T: Triangulo): int =
  var A = 0
  var soma = 0

  if ((T.a.x >= 10 or T.b.y > 20 or T.a.y < 30 or T.b.x <= 50) and not (T.c.x != 90 or T.c.y == 0)):
    return 10 mod 3
  else:
    A = 1

  while A < 10:
    var total = 0
    total = T.c.x * T.c.y
    total = total + T.b.x * T.a.y
    total = total + T.a.x * T.b.y
    soma = soma + total mod 100
    A = A + 1

  return 0

proc fatorialA(n: int): int =
  if n <= 1:
    return 1
  return n * fatorialA(n - 1)

proc fatorialB(n: int): int =
  let a = n - 1
  if n <= 1:
    return 1
  return n * fatorialB(a)

proc fatorialC(n: int, P: int): int =
  if n <= 1:
    return 1
  return fatorialC(n - 1, P * n)

proc fatorialD(n: int, P: int): int =
  let a = n - 1
  let b = P * n
  if n <= 1:
    return 1
  return fatorialD(a, b)

proc fatorialE(n: int, P: int): int =
  if n <= 1:
    return 1
  else:
    let a = n - 1
    let b = P * n
    return fatorialD(a, b)

proc c1(a: int, b: int): int =
  if a < b:
    return 1
  return 2

proc c2(a: int, b: int): int =
  if a <= b:
    return 1
  return 2

proc c3(a: int, b: int): int =
  if a > b:
    return 1
  return 2

proc c4(a: int, b: int): int =
  if a >= b:
    return 1
  return 2

proc c5(a: int, b: int): int =
  if a == b:
    return 1
  return 2

proc c6(a: int, b: int): int =
  if a != b:
    return 1
  return 2

proc d1(a: int, b: int): int =
  if a != b and a < b:
    return 1
  return 2

proc d2(a: int, b: int): int =
  if not (a != b and a < b):
    return 1
  return 2

proc d3(a: int, b: int): int =
  if (not (a != b and a < b)) or (a + 2 == b):
    return 1
  return 2

proc e1(a: int, b: int): int =
  var a = a
  let X = (not (a != b and a < b)) or (a + 2 == b)

  if a != b or X or a + 5 == b:
    a = a + 1

  return 2

proc e2A(a: int, b: int): int =
  var a = a
  var b = b
  let X = (not (a != b and a < b)) or (a + 2 == b)

  while a != b or X or a + 5 == b:
    a = a + 1
    while a < b:
      b = b - 1

  return 2

proc e2B(a: int, b: int): int =
  var a = a
  var b = b
  let X = (not (a != b and a < b)) or (a + 2 == b)

  while a != b or X or a + 5 == b:
    a = a + 1
    while fatorialA(a) < b:
      b = b - 1

  if X or a > 0:
    return 1
  return 0

type
  Ponto2d = object
    x: int
    y: int

  Ponto3d = object
    x: int
    y: int
    z: int

  Segmento2d = object
    ini: Ponto2d
    fim: Ponto2d

  Segmento3d = object
    ini: Ponto3d
    fim: Ponto3d

proc sqrt(x: float): float =
  return x ^ 0.5

proc f1(seg: Segmento2d, p: Ponto2d): float =
  let ax = seg.ini.x
  let ay = seg.ini.y

  let bx = seg.fim.x
  let by = seg.fim.y

  let px = p.x
  let py = p.y

  let abx = bx - ax
  let aby = by - ay

  let apx = px - ax
  let apy = py - ay

  let ab2 = abx * abx + aby * aby

  var t = (apx * abx + apy * aby) / ab2

  if t < 0.0:
    t = 0.0
  if t > 1.0:
    t = 1.0

  let qx = ax + t * abx
  let qy = ay + t * aby

  let dx = px - qx
  let dy = py - qy

  return sqrt(dx * dx + dy * dy)

proc dist2(a: Ponto2d, b: Ponto2d): int =
  let dx = a.x - b.x
  let dy = a.y - b.y
  return dx * dx + dy * dy

proc f2B(seg: Segmento2d, p: Ponto2d): int =
  let ax = seg.ini.x
  let ay = seg.ini.y
  let bx = seg.fim.x
  let by = seg.fim.y

  let px = p.x
  let py = p.y

  let abx = bx - ax
  let aby = by - ay

  let apx = px - ax
  let apy = py - ay

  let bpx = px - bx
  let bpy = py - by

  let dot1 = apx * abx + apy * aby
  let dot2 = bpx * abx + bpy * aby

  if dot1 <= 0:
    return dist2(p, seg.ini)

  if dot2 >= 0:
    return dist2(p, seg.fim)

  let cross = abx * apy - aby * apx

  return (cross * cross) div (abx * abx + aby * aby)

proc areaPoligono(n: int): float =
  var soma = 0
  var i = 0

  while i < n:
    let j = (i + 1) mod n
    soma = soma + i * j - j * i
    i = i + 1

  if soma < 0:
    soma = 0 - soma

  return soma

proc areaPol(): float =
  return areaPoligono(150)

