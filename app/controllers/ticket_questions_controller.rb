class TicketQuestionsController < ApplicationController
  #before_action :authenticate_user!, except: [:mi_metodo]
  before_action :set_ticket_id, only: %i[ actividades nuevo listar email email1]
  before_action :set_question_source, only: %i[ show edit update destroy]
  skip_before_action :authenticate_user!
  #layout "ticket_questions"
  layout 'bootstrap-mailer'

  def actividades
  end

  def nuevo
    #render plain: @question.inspect
    if !@ticketquestion.blank?
       render :template => 'ticket_questions/show'
     end 
  end

  def listar
  end

  def email
  end

  def create
    @question = TicketQuestion.new(question_permit)
    #render plain: @question.inspect
    @question.save
    redirect_to @question
  end
  def edit
  end
  
  def update
    @question.update(question_permit)
    redirect_to @question
  end
  def show
  end

  private

  def set_ticket_id
    @ticket = Ticket.find(params[:id])
    @ticketquestion= TicketQuestion.where("ticket_id = ?", @ticket.id)
    @question = Question.all
    @questionthreads = QuestionThread.all
  end

  def set_question_source
    @question= TicketQuestion.find(params[:id])
    #render plain: @question.inspect
  end
  
  def question_permit
   
    params.require(:question).permit(:ticket_id,:rb_1,:rb_2,:rb_3,:rb_4,:rb_5,:tx_1,:tx_2)
  end

end