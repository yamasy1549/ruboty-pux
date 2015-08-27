require 'mechanize'

module Ruboty
  module Handlers
    class Pux < Base
      env :PUX_REQUEST_DOMAIN, 'Request domain of PUX face-detection API'
      env :PUX_API_KEY, 'Pass PUX API KEY'

      on(
        /judge (?<query>.+)/,
        description: 'Return judgement to 「judge <IMAGE_URL>」',
        name: 'judge'
      )

      def judge(message)
        ruboty_sorry = 'わかんない…'

        p "POST #{request_url}"

        response = agent.post(request_url, params(message))
        face_recognition = JSON.parse(response.body)['results']['faceRecognition']

        if face_recognition['errorInfo'].nil?
          message.reply(ruboty_sorry)
        else
          face_info = face_recognition['detectionFaceInfo'][0]
          gender_info = face_info['genderJudge']['genderResult']

          age     = face_info['ageJudge']['ageResult']       || ruboty_sorry
          animal  = face_info['enjoyJudge']['similarAnimal'] || ruboty_sorry
          smile   = face_info['smileJudge']['smileLevel']    || ruboty_sorry
          doya    = face_info['enjoyJudge']['doyaLevel']     || ruboty_sorry
          trouble = face_info['enjoyJudge']['troubleLevel']  || ruboty_sorry

          if gender_info.nil?
            gender = ruboty_sorry
          else
            gender = gender_info == 0 ? "おとこのこ" : "おんなのこ"
          end

          result_message = ''
          result_message << "ねんれい: #{age}さい"
          result_message << "\nせいべつ: #{gender}"
          result_message << "\nどうぶつ: #{animal}"
          result_message << "\nえがお: #{smile}％"
          result_message << "\nどやがお: #{doya}％"
          result_message << "\nこまった: #{trouble}％"
        end

        message.reply(result_message)
      rescue Exception => e
        Ruboty.logger.error(%<Error: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}>)
        message.reply(ruboty_sorry)
      end

      private

        def request_url
          if ENV['PUX_REQUEST_DOMAIN']
            'http://' + ENV['PUX_REQUEST_DOMAIN'] + ':8080/webapi/face.do'
          end
        end

        def agent
          @agent ||= Mechanize.new
        end

        def params(message)
          {
            apiKey: ENV['PUX_API_KEY'],
            imageURL: message[:query],
            enjoyJudge: 1,
            response: 'json'
          }
        end
    end
  end
end

