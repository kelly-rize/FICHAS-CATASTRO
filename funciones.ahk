; ============================
; SELECCIONAR COMBO
; ============================
SeleccionarCombo(saltos, direccion := "Down") {
    Esperar(200, 350)
    Send("{Space}")          ; abre combo
    Esperar(300, 500)

    tecla := (direccion = "Up") ? "{Up}" : "{Down}"
    Loop saltos {
        Send(tecla)
        Esperar(50, 90)
    }

    Send("{Enter}")
    Esperar(200, 350)
}

LetraASaltos(letra) {
    letra := StrUpper(Trim(letra))
    mapa := Map(
        "A", 1, "B", 2, "C", 3, "D", 4, "E", 5,
        "F", 6, "G", 7, "H", 8, "I", 9
    )
    if !mapa.Has(letra)
        return -1
    return mapa[letra] + 1   ; corrección combo
}