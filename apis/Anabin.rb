require 'grape'
require 'json'
require 'nokogiri'
require 'open-uri'

module API

  class Anabin < Grape::API
    default_format :json

    before do
        header['Access-Control-Allow-Origin'] = '*'
        header['Access-Control-Request-Method'] = '*'
    end

    resource :institution do

      desc "Search for institutions"
      params do
        requires :q, :type => String, :desc => "Query string."
        optional :offset, :type => String, :desc => "Skip 'offset' elements at the beginning of the resultset."
        optional :max, :type => String, :desc => "Maximum count of elements to return (<= 100)."
      end
      get :search do
        # set defaults
        params[:offset] = params[:offset].nil? ? 0 : params[:offset]
        params[:max] = params[:max].nil? ? 10 : params[:max]

        # construct URL
        url = "http://anabin.kmk.org/index.php?eID=user_anabin_institutionen&conf=institutionsergebnisliste&sEcho=3&iColumns=13&iDisplayStart=#{params[:offset]}&iDisplayLength=#{params[:max]}&bRegex=false&iSortingCols=1&iSortCol_0=2&sSortDir_0=asc&s1=#{ URI.escape(params[:q]) }&iDataIds=1"

        data = JSON[ open(url).read ]

        results = data["aaData"].map do |item|
         {
          "uid" => item[1],
          "name" => item[2],
          "location" => item[3],
          "type" => item[4],
          "status" => item[5],
          "country" => item[6],
          "other_fields" => item[7..13]
         }
        end

        response = {
          :meta => {
            :anabin_url => url,
            :result_count => results.size
          },
          :results => results
        }

        response
      end


      desc "Details about one institution"
      params do
        requires :id, :type => Integer, :desc => "institution id."
      end
      get ":id" do
        url = "http://anabin.kmk.org/index.php?eID=user_anabin_institutionen&conf=institutionen&uid=#{params[:id]}"
        # doc = Nokogiri::HTML(open(url))

        data = open(url).read

        # hack from here:
        # http://stackoverflow.com/questions/1530324/ruby-xml-to-json-converter
        Hash.from_xml("<institution>#{data}</div></institution>")   
      end

    end # end institution



    resource :degree do

      desc "Search for degrees"
      params do
        requires :q, :type => String, :desc => "Query string."
        optional :offset, :type => String, :desc => "Skip 'offset' elements at the beginning of the resultset."
        optional :max, :type => String, :desc => "Maximum count of elements to return (<= 100)."
      end
      get :search do
        # set defaults
        params[:offset] = params[:offset].nil? ? 0 : params[:offset]
        params[:max] = params[:max].nil? ? 10 : params[:max]

        # construct URL
        url = "http://anabin.kmk.org/index.php?eID=user_anabin_abschluesse&conf=abschlussergebnisliste&sEcho=3&iColumns=13&iDisplayStart=#{params[:offset]}&iDisplayLength=#{params[:max]}&bRegex=false&iSortingCols=1&iSortCol_0=2&sSortDir_0=asc&s1=#{ URI.escape(params[:q]) }&iDataIds=1"

        data = JSON[ open(url).read ]

        results = data["aaData"].map do |item|
         {
          "uid" => item[1],
          "degree" => item[2],
          "degree_type" => item[3],
          "duration_min" => item[4],
          "duration_max" => item[5],
          "class" => item[6],
          "subject" => item[7],
          "country" => item[8],
          "other_fields" => item[9..13]
         }
        end

        response = {
          :meta => {
            :anabin_url => url,
            :result_count => results.size
          },
          :results => results
        }

        response
      end

    end # end :degree

  end

end