#I.Generarea numerelor aleatoare
#Cu functia sample()
x = sample(300,1)
x

#Genereaza 5 nr aleatoare intregi de la 200 la 250
x = sample(200:250,5) 
x
x = sample(5,5) 
x

#Pentru a genera nr aleatorii cu repetitie
x = sample(30, 6, replace=T)
x
 
x = sample(20:40, 5, replace=T)
x

#Poate genera un esantion(submultime) format din elemente ale unui vector indicat:
x = c(2.1, 3.2, 2.3, 2.5, 3.1, 2.9, 2.6, 2.2, 3.3)
sample(x, 5) #ex: 3.1 2.2 3.2 2.9 3.2
sample(x, 5, replace=T)  #ex: 3.1 2.2 3.2 2.9 3.2
runif(10, 2, 4.5)
  
#Poate fi folosita si pentru a genera permutari aleatoare:
sample(10) # 10 nr aleatorii pana la 10(inclusiv):3 2 5 7 8 10 6 9 1 4
sample(15) # 9 6 7 4 11 15 10 3 12 2 1 13 8 5 14




#II.Algoritmi aleatori
#1.Monte Carlo
#Functia matrix(data, nrow, ncol, byrow) creaza o matrice (data este lista elementelor pe linie, byrow este implicit FALSE):

 x = c(1, 3, 1, 4, 12, 7)
 M = matrix(x, 3, 2)# creates a matrix 3x2
 M
 N= matrix(x, 2, 3)# creates a matrix 2x3
 N

#Urmatoarea functie verifica daca ABr = Cr pentru un vector uniform generat, r, de componente 0 sau 1.
 matrixproduct = function(A, B, C) {
   n = nrow(A)
   r = matrix( , nrow = n, ncol = 1)
   x = matrix( , nrow = n, ncol = 1)
   y = matrix( , nrow = n, ncol = 1)
   r = sample(0:1, n, replace = TRUE)
   for(i in 1:n) {# x = Br
     x[i] = 0
     for(j in 1:nrow(B))
       x[i] = (x[i]+ B[i,j]*r[j])%%2
   }
   for(i in 1:nrow(B)) {# y = Ax = ABr
     y[i] = 0
     for(j in 1:n)
       y[i] = (y[i]+ A[i,j]*x[j])%%2
   }
   for(i in 1:n) {# x = Cr
     x[i] = 0
     for(j in 1:n)
       x[i] = (x[i]+ C[i,j]*r[j])%%2
   }
   for(i in 1:n) {# verify if ABr==Cr
     if(y[i] !=x[i])
       return(FALSE)
   }
   return(TRUE)
 }

 x=c(0,0,1,0,1,0,1,1,0)
 A=matrix(x,3,3)

 y=c(1,1,0,1,0,1,1,1,0)
 B=matrix(y,3,3)
 D=A%*%B
 D
 z=c(0,0,0,0,0,0,0,0,1)
 M=matrix(z,3,3)
 C=D-M
 C
 matrixproduct(A,B,C)


 #Functia de mai jos da o probabilitate a erorii sub 2^-k.
 matrixproductreduce = function(A, B, C, k) {
   for(i in 1:k)
     if(!matrixproduct(A, B, C))
       return(FALSE)
 return(TRUE)
 }
matrixproductreduce(A,B,C,10)



#2.Las Vegas
#=>”game tree” de adancime 2h; arborele este dat ca un vector care contine cele 4h valori din frunze.
leaves = c(0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0)
treeeval = function(i, leaves) {
  a = runif(1, 0, 1)
  len = length(leaves)
  if(log(i,2) >= log(len,2) - 1) { # copiii nodului i sunt frunze
    if(a <= 0.5) {
      if(leaves[2*i - len + 1] == 0)#se alege copilul din st
        return(leaves[2*i +1 -len + 1])
               return(1)}
    else {
      if(leaves[2*i + 1 -len + 1] == 0)
        return(leaves[2*i -len + 1])
               return(1)
    }
  }
  if((floor(log(i,2))%% 2 == 0)){ # nodul i este de tip MIN
    if(a <= 0.5) {
      if(treeeval(2*i, leaves) == 1) 
        return(treeeval(2*i + 1, leaves))
      return(0) } 
      else {
        if(treeeval(2*i +1, leaves) == 1)
          return(treeeval(2*i, leaves))
        return(0)
      }
    }
  if((floor(log(i,2))%% 2 == 1)){ # nodul i este de tip MAX
      if(a <= 0.5) {
        if(treeeval(2*i, leaves) == 0) 
          return(treeeval(2*i + 1, leaves))
        return(1)}  #
        else {
          if(treeeval(2*i +1, leaves) == 0)
            return(treeeval(2*i, leaves))
          return(1)
        }
    }
}
leaves = c(0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0)
treeeval(1,leaves)


#Exerciti propuse:
#1.
simulare_variabila_aleatoare = function(val, prob) {
    if (length(val) != length(prob)) {
        stop("Lungimea listelor de val și prob diferita, deci eroare.")
    }
    r = runif(1)
    suma_prob = 0

    for (i in 1:length(val)) {
        suma_prob = suma_prob + prob[i]
        if (r <= suma_prob)
            return(valori[i])
    }
    stop("Prob nu sunt valide.")
}

valori = c("A", "B", "C")
probabilitati = c(0.3, 0.4, 0.3)

print(simulare_variabila_aleatoare(valori, probabilitati))
