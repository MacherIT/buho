class CalendarioController < ApplicationController
  def index

    @meses = []
    (1..12).each do |index|
      @meses[index - 1] = {
        nombre: Date::MONTHNAMES[index],
        dias: {}
      }
      Time.days_in_month(index).times do |dia|
        @meses[index - 1][:dias]["#{Time.now.year}-#{index}-#{dia+1}"] = {
          fecha: "#{Time.now.year}-#{index}-#{dia+1}",
          posts: []
        }
      end
    end

    @posts = Post.all.as_json(methods: [:img, :cliente_logo])
    @redes = Red.all
  end
end
