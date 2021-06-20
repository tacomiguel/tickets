namespace :tickets do
  desc "TODO"
  task init: :environment do
    TicketPriority.create([
      { name: 'Baja',    color: nil, priority: 1 },
      { name: 'Normal',  color: nil, priority: 2 },
      { name: 'Alta',    color: nil, priority: 3 },
      { name: 'Urgente', color: nil, priority: 4 }
    ])

    TicketStatus.create([
      { name: 'Abierto', sort: 1, default: 1, system_status: 1 },
      { name: 'Cerrado', sort: 2, system_status: 1 },
    ])

    TicketSource.create(name: 'TICKET')

    Question.create(name: '¿En cuanto a la atención de su requerimiento?', campo: 'rb_1')
    Question.create(name: '¿Cómo fue la atención para solucionar su requerimiento?', campo: 'rb_2')
    Question.create(name: '¿Cuál es la probabilidad de que nos recomiende con sus conocidos?', campo: 'rb_3')
    Question.create(name: 'En general ¿qué tan satisfecho esta con esta compañía?', campo: 'rb_4')
    Question.create(name: '¿Cual es el aspecto ó aspectos que mejoraría en su experiencia con nuestra marca?', campo: 'txs_1')

    QuestionThread.create(name: '1.-Altamente Satisfecho', valor: 1, question_id: 1)
    QuestionThread.create(name: '2.-Muy Satisfecho', valor: 2, question_id: 1)
    QuestionThread.create(name: '3.-Satisfecho', valor: 3, question_id: 1)
    QuestionThread.create(name: '4.-Poco Satisfecho', valor: 4, question_id: 1)
    QuestionThread.create(name: '5.-Completamente insatisfecho', valor: 5, question_id: 1)
    QuestionThread.create(name: '1.-Rápida, pues solucionaron al momento', valor: 1, question_id: 2)
    QuestionThread.create(name: '2.-Tuve que esperar, pero me solucionaron', valor: 2, question_id: 2)
    QuestionThread.create(name: '3.-Insuficiente, pues no recibí solución', valor: 3, question_id: 2)
    QuestionThread.create(name: '1.-Si los recomiendo', valor: 1, question_id: 3)
    QuestionThread.create(name: '2.-Es muy probable', valor: 2, question_id: 3)
    QuestionThread.create(name: '3.-Es probable', valor: 3, question_id: 3)
    QuestionThread.create(name: '4.-Es poco probable', valor: 4, question_id: 3)
    QuestionThread.create(name: '1.-Altamente Satisfecho', valor: 1, question_id: 4)
    QuestionThread.create(name: '2.-Muy Satisfecho', valor: 2, question_id: 4)
    QuestionThread.create(name: '3.-Satisfecho', valor: 3, question_id: 4)
    QuestionThread.create(name: '4.-Poco Satisfecho', valor: 4, question_id: 4)
    QuestionThread.create(name: '5.-Completamente insatisfecho', valor: 5, question_id: 4)
  end
end
