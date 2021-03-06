# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

class PokesController < ApplicationController
  before_action :set_poke, only: [:show, :edit, :update, :destroy]

  def index
    @pokes = Poke.all.order(number: :asc)
    p '--------------------'
    # getPoke()
  end

  def show
  end

  def pokemon
  end

  def poke_search
    @poke = Poke.where('name like ?', '%' + params[:keyword] + '%').first
    @output = params[:output].to_s
  end

  def new
    @poke = Poke.new
  end

  def edit
  end

  def create
    @poke = Poke.new(poke_params)

    respond_to do |format|
      if @poke.save
        format.html { redirect_to @poke, notice: 'Poke was successfully created.' }
        format.json { render :show, status: :created, location: @poke }
      else
        format.html { render :new }
        format.json { render json: @poke.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @poke.update(poke_params)
        format.html { redirect_to @poke, notice: 'Poke was successfully updated.' }
        format.json { render :show, status: :ok, location: @poke }
      else
        format.html { render :edit }
        format.json { render json: @poke.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @poke.destroy
    respond_to do |format|
      format.html { redirect_to pokes_url, notice: 'Poke was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def auto_complete
    @pokes = Poke.select('name').where('name like ?', params[:term].to_s.tr('ぁ-ん','ァ-ン') + '%').order(number: :asc)

    p params[:term].to_s
    p @pokes.count
    render json: @pokes.to_json
  end

  private
    def set_poke
      @poke = Poke.find(params[:id])
    end

    def poke_params
      params.require(:poke).permit(:name, :h, :a, :b, :c, :d, :s, :type_1, :type_2)
    end

    def getPoke
      p '22222222222222222222222222'
      pokelist = Nokogiri::HTML.parse(url_set("https://wiki.xn--rckteqa2e.com/wiki/%E7%A8%AE%E6%97%8F%E5%80%A4%E4%B8%80%E8%A6%A7_(%E7%AC%AC%E5%85%AB%E4%B8%96%E4%BB%A3)"), nil, 'utf-8')
      p pokelist.title

      pokelist.css('#mw-content-text > div > table > tbody > tr').each do |doc|
        pokemon = Poke.new
        pokemon.number = doc.css('th:nth-child(1)').inner_text
        pokemon.name = doc.css('th.l').inner_text
        p doc.css('th.l').inner_text
        pokemon.type_1 = what_type(doc.css('td:nth-child(3)').inner_text)
        if doc.css('td:nth-child(4)').present?
          p doc.css('td:nth-child(4)').inner_text
          pokemon.type_2 = what_type(doc.css('td:nth-child(4)').inner_text)
        end

        p doc.css('td:nth-child(5)').inner_text
        pokemon.h = doc.css('td:nth-child(5)').inner_text
        p doc.css('td:nth-child(6)').inner_text
        pokemon.a = doc.css('td:nth-child(6)').inner_text
        p doc.css('td:nth-child(7)').inner_text
        pokemon.b = doc.css('td:nth-child(7)').inner_text
        p doc.css('td:nth-child(8)').inner_text
        pokemon.c = doc.css('td:nth-child(8)').inner_text
        p doc.css('td:nth-child(9)').inner_text
        pokemon.d = doc.css('td:nth-child(9)').inner_text
        p doc.css('td:nth-child(10)').inner_text
        pokemon.s = doc.css('td:nth-child(10)').inner_text

        pokemon.save
      end
    end

    def url_set(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      return html
    end

    def what_type(n)
      if n == 'ノーマル'
        return 1
      elsif n == 'ほのお'
        return 2
      elsif n == 'みず'
        return 3
      elsif n == 'でんき'
        return 4
      elsif n == 'くさ'
        return 5
      elsif n == 'こおり'
        return 6
      elsif n == 'かくとう'
        return 7
      elsif n == 'どく'
        return 8
      elsif n == 'じめん'
        return 9
      elsif n == 'ひこう'
        return 10
      elsif n == 'エスパー'
        return 11
      elsif n == 'むし'
        return 12
      elsif n == 'いわ'
        return 13
      elsif n == 'ゴースト'
        return 14
      elsif n == 'ドラゴン'
        return 15
      elsif n == 'あく'
        return 16
      elsif n == 'はがね'
        return 17
      elsif n == 'フェアリー'
        return 18
      end
    end
end
