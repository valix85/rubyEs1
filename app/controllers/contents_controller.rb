class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_user, only: [:edit, :update, :destroy]
  # GET /contents
  # GET /contents.json
  def index
    #@contents = Content.all.order("created_at DESC").limit(2).offset(1)
    #@contents = Content.all.order("created_at DESC")
    @contents = Content.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 4)
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  # GET /contents/new
  def new
    #@content = Content.new
    #@content = current_user.contentes, notice: "Contnuto inserito"
    @content = current_user.contents.build
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    #@content = Content.new(content_params)
    @content = current_user.contents.build(content_params)
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Contenuto creato con successo' }
        format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Contenuto aggiornato con successo' }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy
    respond_to do |format|
      format.html { redirect_to contents_url, notice: 'Contenuto eliminato con successo' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:titolo, :descrizione, :price, :cover, :allegato)
    end

    def check_user
      if current_user != @content.user
        redirect_to root_url, alert:"Non hai il permesso per questa azione"
      end
    end  
end
