enum ExerciseGuideContent {
    static let guides: [ExerciseGuide] = [
        guide(
            "monday-machine-chest-press", "Empujar horizontalmente con una trayectoria estable.",
            "Pectoral, tríceps y deltoide anterior", "Máquina de press de pecho",
            "Ajusta el asiento: empuñaduras a media altura del pecho; espalda y pies apoyados.",
            ["Sujeta las empuñaduras y estabiliza los hombros.", "Empuja al frente sin bloquear los codos.", "Vuelve despacio hasta un estiramiento cómodo."],
            ["Elevar hombros", "Despegar la espalda", "Rebotar al final"], "Exhala al empujar e inhala al regresar."
        ),
        guide(
            "monday-dumbbell-chest-press", "Empujar horizontalmente con cargas independientes.",
            "Pectoral, tríceps y deltoide anterior", "Banco plano y mancuernas",
            "Apoya cabeza y espalda en el banco; coloca pies firmes y mancuernas junto al pecho.",
            ["Alinea las muñecas sobre los codos.", "Empuja las mancuernas hacia arriba sin chocarlas.", "Bájalas controladamente hasta una amplitud cómoda."],
            ["Arquear la zona lumbar", "Abrir excesivamente los codos", "Juntar las mancuernas con golpe"], "Exhala al empujar e inhala al bajar."
        ),
        guide(
            "monday-machine-incline-press", "Empujar en un plano inclinado con soporte estable.",
            "Pectoral superior, deltoide anterior y tríceps", "Máquina de press inclinado",
            "Ajusta el asiento para iniciar con las manos cerca de la parte alta del pecho; apoya espalda y pies.",
            ["Estabiliza hombros y tronco contra el respaldo.", "Empuja siguiendo el recorrido de la máquina.", "Regresa despacio sin forzar el hombro."],
            ["Arquear la espalda", "Bajar más allá de una amplitud cómoda", "Acortar el recorrido por exceso de carga"], "Exhala al empujar e inhala al regresar."
        ),
        guide(
            "monday-pec-deck", "Acercar los brazos para trabajar el pecho con control.",
            "Pectoral mayor", "Máquina pec deck", "Ajusta el asiento y los apoyos para que los brazos queden a la altura del pecho.",
            ["Apoya la espalda y conserva el pecho elevado.", "Cierra los brazos sin golpearlos.", "Abre despacio hasta un estiramiento cómodo."],
            ["Llevar los codos demasiado atrás", "Encoger los hombros", "Golpear las placas"], "Exhala al cerrar e inhala al abrir."
        ),
        guide(
            "monday-shoulder-press", "Empujar hacia arriba manteniendo el tronco estable.",
            "Deltoides y tríceps", "Máquina de press de hombros",
            "Ajusta el asiento para comenzar con empuñaduras cerca de los hombros; espalda apoyada.",
            ["Afirma el abdomen y conserva las muñecas alineadas.", "Empuja sin bloquear los codos.", "Desciende de forma controlada."],
            ["Arquear demasiado la espalda", "Usar impulso", "Forzar una profundidad incómoda"], "Exhala al empujar e inhala al bajar."
        ),
        guide(
            "monday-cable-lateral-raise", "Elevar el brazo hacia el costado con tensión continua.",
            "Deltoide lateral", "Polea baja con una empuñadura",
            "Colócate de lado a la polea y sujeta la empuñadura con el brazo ligeramente flexionado.",
            ["Mantén el torso quieto y la muñeca neutra.", "Eleva el brazo hacia el costado hasta cerca del hombro.", "Baja lentamente sin soltar la tensión."],
            ["Balancear el torso", "Encoger el hombro", "Elevar muy por encima del hombro"], "Exhala al elevar e inhala al bajar."
        ),
        guide(
            "monday-machine-lateral-raise", "Elevar los brazos lateralmente contra una resistencia guiada.",
            "Deltoide lateral", "Máquina de elevación lateral",
            "Ajusta asiento y apoyos para que los brazos empiecen en una posición cómoda.",
            ["Apoya el torso y relaja el cuello.", "Eleva los codos hacia los lados de forma controlada.", "Desciende sin dejar caer los brazos."],
            ["Impulsar con el cuerpo", "Subir los hombros", "Usar un recorrido doloroso"], "Exhala al elevar e inhala al descender."
        ),
        guide(
            "monday-rope-triceps", "Extender los codos con el brazo superior estable.",
            "Tríceps", "Polea alta con cuerda", "Ajusta la polea arriba y sujeta la cuerda con codos junto al torso.",
            ["Mantén inmóviles los brazos superiores.", "Extiende los codos y separa suavemente los extremos.", "Flexiónalos despacio hasta una posición cómoda."],
            ["Mover los codos hacia delante", "Inclinarse para generar impulso", "Dejar subir el peso de golpe"], "Exhala al extender e inhala al volver."
        ),
        guide(
            "tuesday-lat-pulldown", "Llevar los brazos desde arriba hacia el torso.",
            "Dorsal ancho, espalda media y bíceps", "Polea alta con barra",
            "Ajusta el soporte de muslos y toma la barra algo más ancha que los hombros.",
            ["Siéntate erguido con el pecho abierto.", "Lleva los codos hacia abajo y la barra al pecho alto.", "Extiende los brazos lentamente sin perder control."],
            ["Llevar la barra tras la nuca", "Balancearse", "Tirar solo con las manos"], "Exhala al bajar e inhala al subir."
        ),
        guide(
            "tuesday-seated-cable-row", "Remar hacia el torso con una postura estable.",
            "Espalda media, dorsal y bíceps", "Polea baja con empuñadura",
            "Siéntate con rodillas ligeramente flexionadas y columna neutra.",
            ["Empieza con brazos extendidos y hombros controlados.", "Lleva la empuñadura hacia el abdomen.", "Regresa despacio sin redondear la espalda."],
            ["Balancear el torso", "Elevar los hombros", "Redondear la espalda"], "Exhala al remar e inhala al extender."
        ),
        guide(
            "tuesday-converging-row", "Acercar los codos al cuerpo en un remo guiado.",
            "Dorsales, romboides y trapecio medio", "Máquina de remo convergente",
            "Ajusta el asiento y apoya el pecho si la máquina tiene almohadilla.",
            ["Toma las empuñaduras con hombros relajados.", "Lleva los codos atrás sin despegar el pecho.", "Haz una pausa breve y regresa controladamente."],
            ["Tirar con impulso", "Despegar el pecho", "Encoger los hombros"], "Exhala al tirar e inhala al regresar."
        ),
        guide(
            "tuesday-cable-pullover", "Llevar los brazos hacia abajo manteniendo los codos casi extendidos.",
            "Dorsal ancho y redondo mayor", "Polea alta con barra o cuerda",
            "Colócate frente a la polea; inclina levemente el torso y suaviza los codos.",
            ["Estabiliza abdomen y costillas.", "Describe un arco llevando el accesorio hacia los muslos.", "Vuelve despacio hasta una amplitud cómoda."],
            ["Flexionar mucho los codos", "Convertirlo en empuje de tríceps", "Arquear la espalda"], "Exhala al bajar e inhala al subir."
        ),
        guide(
            "tuesday-face-pull", "Llevar la cuerda hacia el rostro con los hombros controlados.",
            "Deltoide posterior y espalda alta", "Polea alta con cuerda",
            "Coloca la polea a la altura de la cara y toma la cuerda con ambas manos.",
            ["Da un paso atrás y estabiliza el torso.", "Tira hacia la cara separando las manos.", "Regresa lentamente con hombros bajos."],
            ["Tirar hacia el pecho", "Arquear la espalda", "Usar una carga que desordene la postura"], "Exhala al tirar e inhala al regresar."
        ),
        guide(
            "tuesday-scott-curl", "Flexionar los codos con los brazos apoyados.",
            "Bíceps y braquial", "Banco Scott y barra o mancuernas",
            "Ajusta el asiento y apoya los brazos completos sobre la almohadilla.",
            ["Sujeta la carga sin doblar las muñecas.", "Flexiona los codos sin despegar los brazos.", "Baja despacio sin bloquear bruscamente."],
            ["Despegar los brazos", "Usar impulso", "Soltar la bajada"], "Exhala al flexionar e inhala al bajar."
        ),
        guide(
            "tuesday-machine-curl", "Flexionar los codos contra una resistencia guiada.",
            "Bíceps y braquial", "Máquina de curl de bíceps",
            "Ajusta el asiento y alinea los codos con el eje de giro.",
            ["Apoya los brazos y sujeta las empuñaduras.", "Flexiona los codos sin elevar los hombros.", "Extiende despacio dentro de un rango cómodo."],
            ["Mover los brazos sobre la almohadilla", "Impulsar el torso", "Bajar de golpe"], "Exhala al flexionar e inhala al extender."
        ),
        guide(
            "thursday-incline-leg-press", "Empujar la plataforma con piernas y caderas estables.",
            "Cuádriceps, glúteos y femorales", "Prensa de piernas inclinada",
            "Coloca los pies aproximadamente al ancho de hombros y libera los seguros según la máquina.",
            ["Baja la plataforma de forma controlada.", "Mantén las rodillas alineadas con los pies.", "Empuja con toda la planta sin bloquear las rodillas."],
            ["Despegar la pelvis del respaldo", "Juntar las rodillas", "Bajar más allá de una posición controlada"], "Inhala al bajar y exhala al empujar."
        ),
        guide(
            "thursday-hack-squat", "Flexionar y extender las piernas con el torso apoyado.",
            "Cuádriceps, glúteos y aductores", "Máquina hack squat",
            "Apoya espalda y hombros; coloca los pies estables en la plataforma.",
            ["Desciende flexionando caderas y rodillas.", "Mantén las rodillas en línea con los pies.", "Empuja para subir sin bloquear bruscamente."],
            ["Levantar los talones", "Dejar caer las rodillas hacia dentro", "Rebotar abajo"], "Inhala al bajar y exhala al subir."
        ),
        guide(
            "thursday-guided-squat", "Hacer una sentadilla con una barra guiada y apoyos estables.",
            "Cuádriceps, glúteos y aductores", "Máquina Smith",
            "Coloca la barra sobre la parte alta de la espalda y los pies en una posición cómoda bajo ella.",
            ["Desbloquea la barra y afirma el tronco.", "Desciende manteniendo rodillas alineadas con los pies.", "Empuja el suelo para volver y asegura la barra al terminar."],
            ["Colocar la barra sobre el cuello", "Levantar los talones", "Usar una profundidad que altere la postura"], "Inhala al bajar y exhala al subir."
        ),
        guide(
            "thursday-seated-leg-curl", "Flexionar las rodillas desde una posición sentada.",
            "Isquiotibiales", "Máquina de curl femoral sentado",
            "Alinea las rodillas con el eje y ajusta los apoyos sobre los muslos y tobillos.",
            ["Mantén la pelvis contra el respaldo.", "Flexiona las rodillas hasta una contracción cómoda.", "Extiende lentamente sin soltar la carga."],
            ["Levantar la cadera", "Usar impulso", "Dejar que la carga regrese de golpe"], "Exhala al flexionar e inhala al extender."
        ),
        guide(
            "thursday-lying-leg-curl", "Flexionar las rodillas desde una posición boca abajo.",
            "Isquiotibiales", "Máquina de curl femoral acostado",
            "Alinea las rodillas con el eje y coloca el rodillo sobre la parte baja de las piernas.",
            ["Sujeta los apoyos y conserva la pelvis sobre el banco.", "Flexiona las rodillas de forma controlada.", "Baja despacio hasta extenderlas cómodamente."],
            ["Elevar la pelvis", "Balancear las piernas", "Soltar la bajada"], "Exhala al flexionar e inhala al extender."
        ),
        guide(
            "thursday-leg-extension", "Extender las rodillas contra una resistencia guiada.",
            "Cuádriceps", "Máquina de extensión de piernas",
            "Alinea la rodilla con el eje y apoya el rodillo sobre la parte baja de la tibia.",
            ["Sujeta los agarres y conserva la espalda apoyada.", "Extiende sin golpear el tope.", "Baja lentamente a la posición inicial."],
            ["Desalinear la rodilla", "Despegar la cadera", "Rebotar abajo"], "Exhala al extender e inhala al bajar."
        ),
        guide(
            "thursday-machine-hip-thrust", "Extender la cadera con apoyo de espalda y carga guiada.",
            "Glúteos y femorales", "Máquina de hip thrust",
            "Ajusta la almohadilla sobre la cadera y apoya los pies firmemente.",
            ["Baja la cadera manteniendo el tronco estable.", "Empuja hasta alinear hombros, cadera y rodillas.", "Aprieta glúteos sin arquear la espalda."],
            ["Empujar solo con las puntas", "Hiperextender la espalda", "Colocar los pies demasiado lejos"], "Inhala al bajar y exhala al elevar."
        ),
        guide(
            "thursday-machine-calf-raise", "Elevar y bajar los talones con recorrido controlado.",
            "Pantorrilla", "Máquina de gemelos", "Apoya el antepié en la plataforma y deja libre el movimiento del talón.",
            ["Baja el talón lentamente hasta un estiramiento cómodo.", "Eleva el talón todo el recorrido controlable.", "Haz una pausa breve y repite."],
            ["Rebotar", "Acortar el recorrido", "Girar los tobillos"], "Exhala al elevar e inhala al bajar."
        ),
        guide(
            "saturday-dumbbell-incline-press", "Empujar en banco inclinado con cargas independientes.",
            "Pectoral superior, tríceps y deltoide anterior", "Banco inclinado y mancuernas",
            "Ajusta el respaldo a una inclinación moderada; apoya espalda y pies.",
            ["Sostén las mancuernas sobre el pecho con muñecas estables.", "Empuja arriba y ligeramente hacia dentro sin chocarlas.", "Baja controladamente hasta un rango cómodo."],
            ["Inclinar demasiado el banco", "Perder el apoyo de los pies", "Chocar las mancuernas"], "Exhala al empujar e inhala al bajar."
        ),
        guide(
            "saturday-neutral-grip-pulldown", "Llevar un agarre neutro desde arriba hacia el pecho.",
            "Dorsal ancho, bíceps y espalda media", "Polea alta con agarre neutro",
            "Ajusta el soporte de muslos y toma el accesorio con palmas enfrentadas.",
            ["Eleva el pecho y estabiliza el torso.", "Lleva los codos abajo hacia los costados.", "Devuelve el agarre lentamente hasta extender los brazos."],
            ["Balancearse", "Encoger los hombros", "Tirar el agarre demasiado abajo"], "Exhala al bajar e inhala al subir."
        ),
        guide(
            "saturday-chest-supported-row", "Remar con el pecho apoyado para estabilizar el torso.",
            "Romboides, trapecio medio, dorsal y bíceps", "Máquina con apoyo o banco inclinado",
            "Ajusta el apoyo y coloca el pecho contra él; conserva el cuello relajado.",
            ["Sujeta las cargas con muñecas neutras.", "Lleva los codos atrás sin despegar el pecho.", "Pausa brevemente y baja despacio."],
            ["Despegar el pecho", "Elevar los hombros", "Acortar el recorrido"], "Exhala al remar e inhala al bajar."
        ),
        guide(
            "saturday-lateral-raise", "Elevar los brazos a los lados con el tronco quieto.",
            "Deltoide lateral", "Mancuernas, polea baja o máquina; usa el equipo disponible.",
            "Deja una ligera flexión en los codos y adopta una postura estable.",
            ["Inicia con los brazos junto al cuerpo.", "Eleva hasta cerca de la altura de los hombros.", "Baja lentamente sin dejar caer la resistencia."],
            ["Balancear el torso", "Encoger los hombros", "Girar las manos en exceso"], "Exhala al subir e inhala al bajar."
        ),
        guide(
            "saturday-cable-triceps", "Extender los codos contra una resistencia de polea.",
            "Tríceps", "Polea alta", "Ajusta la polea y colócate con los codos cerca del torso.",
            ["Estabiliza los brazos superiores.", "Extiende los codos y contrae el tríceps.", "Regresa lentamente sin mover los hombros."],
            ["Abrir los codos", "Usar impulso", "Inclinar demasiado el cuerpo"], "Exhala al extender e inhala al regresar."
        ),
        guide(
            "saturday-cable-curl", "Flexionar los codos con resistencia continua de polea.",
            "Bíceps y braquial", "Polea baja con barra", "Sujeta la barra con codos cerca del torso y muñecas alineadas.",
            ["Mantén el tronco quieto.", "Flexiona los codos sin adelantarlos.", "Baja de forma controlada."],
            ["Balancearse", "Mover los codos hacia delante", "Soltar el peso"], "Exhala al subir e inhala al bajar."
        ),
        guide(
            "sunday-dumbbell-rdl", "Llevar la cadera atrás mientras las cargas recorren las piernas.",
            "Isquiotibiales, glúteos y erectores", "Mancuernas",
            "Sujeta las mancuernas delante de los muslos y flexiona ligeramente las rodillas.",
            ["Lleva la cadera atrás con columna neutra.", "Desciende las cargas cerca de las piernas hasta sentir tensión cómoda.", "Empuja la cadera al frente para volver erguido."],
            ["Redondear la espalda", "Convertir el gesto en sentadilla", "Alejar las cargas del cuerpo"], "Inhala al bajar y exhala al subir."
        ),
        guide(
            "sunday-leg-curl", "Flexionar las rodillas en una máquina de curl.",
            "Isquiotibiales", "Máquina de curl femoral",
            "Alinea la rodilla con el eje y ajusta los apoyos a la máquina disponible.",
            ["Fija la pelvis contra el apoyo.", "Flexiona las rodillas de manera controlada.", "Regresa lentamente sin perder tensión."],
            ["Levantar la cadera", "Rebotar", "Usar un rango incómodo"], "Exhala al flexionar e inhala al regresar."
        ),
        guide(
            "sunday-leg-press", "Empujar la plataforma con una postura cómoda y controlada.",
            "Cuádriceps, glúteos y femorales", "Prensa de piernas",
            "Coloca los pies en una postura natural donde puedas mantener espalda y pelvis apoyadas.",
            ["Desciende la plataforma dentro de un rango cómodo.", "Mantén las rodillas alineadas con los pies.", "Empuja sin bloquear por completo las rodillas."],
            ["Despegar la cadera", "Cerrar las rodillas", "Usar más carga de la que controlas"], "Inhala al bajar y exhala al empujar."
        ),
        guide(
            "sunday-abductors", "Separar las piernas contra una resistencia guiada.",
            "Glúteo medio y menor", "Máquina de abductores",
            "Siéntate con espalda apoyada y piernas colocadas contra las almohadillas.",
            ["Abre las rodillas sin balancear el tronco.", "Haz una pausa breve al final del recorrido.", "Regresa lentamente sin juntar de golpe."],
            ["Inclinarse con impulso", "Usar un recorrido mínimo", "Dejar caer la carga"], "Exhala al abrir e inhala al cerrar."
        ),
        guide(
            "sunday-machine-crunch", "Acercar las costillas a la pelvis contra resistencia guiada.",
            "Recto abdominal y oblicuos", "Máquina de abdominales", "Ajusta los apoyos y estabiliza la pelvis en el asiento.",
            ["Inicia con el tronco erguido y abdomen activo.", "Flexiona el tronco sin tirar con los brazos.", "Vuelve lentamente sin perder control."],
            ["Mover solo la cadera", "Tirar del cuello", "Usar impulso"], "Exhala al flexionar e inhala al volver."
        ),
        guide(
            "sunday-cable-crunch", "Flexionar el tronco hacia abajo con tensión de polea.",
            "Recto abdominal y oblicuos", "Polea alta con cuerda",
            "Arrodíllate frente a la polea y sujeta la cuerda junto a la cabeza sin tirar del cuello.",
            ["Fija la pelvis y activa el abdomen.", "Acerca las costillas a la pelvis flexionando el tronco.", "Regresa despacio sin convertir el gesto en una bisagra de cadera."],
            ["Tirar con los brazos", "Flexionar solo la cadera", "Usar impulso"], "Exhala al flexionar e inhala al regresar."
        ),
        guide(
            "sunday-plank", "Mantener el tronco alineado durante un intervalo.",
            "Abdominales, oblicuos y estabilizadores", "Colchoneta",
            "Apoya antebrazos y puntas de los pies; separa los codos bajo los hombros.",
            ["Alinea cabeza, tronco y talones.", "Activa abdomen y glúteos sin contener la respiración.", "Mantén la posición el tiempo indicado y termina con control."],
            ["Dejar caer la cadera", "Elevar demasiado los glúteos", "Contener la respiración"], "Respira de forma lenta y continua durante toda la posición."
        ),
    ]

    private static func guide(
        _ id: String,
        _ purpose: String,
        _ target: String,
        _ equipment: String,
        _ setup: String,
        _ steps: [String],
        _ commonErrors: [String],
        _ breathing: String
    ) -> ExerciseGuide {
        ExerciseGuide(id: id, purpose: purpose, target: target, equipment: equipment, setup: setup, steps: steps, commonErrors: commonErrors, breathing: breathing)
    }
}
