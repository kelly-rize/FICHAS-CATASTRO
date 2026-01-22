Esperar(min := 150, max := 400) {
    Sleep(Random(min, max))
}

ActivarCatastro() {
    WinActivate("SISTEMA DE CATASTRO")
    WinWaitActive("SISTEMA DE CATASTRO", , 3)
    Esperar(200, 350)
}