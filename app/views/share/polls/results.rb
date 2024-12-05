module Share
  module Polls
    class Results < ApplicationComponent
      include PhlexConcerns::NestedDomId
      include Phlex::Rails::Helpers::Pluralize

      attr_reader :poll

      def initialize(poll)
        @poll = poll
      end

      def view_template
        div id: dom_id(poll, :results) do
          poll.questions.ordered.each do |question|
            div id: nested_dom_id(poll, question),
              class: "question flex flex-col gap-2" do
              p { question.body }

              question.answers.ordered.each do |answer|
                render AnswerBar.new(answer, question)
              end

              div(class: "p-2") do
                p(class: "text-small font-extrabold") { pluralize question.votes_count, "vote" }
              end
            end
          end
        end
      end

      class AnswerBar < ApplicationComponent
        include PhlexConcerns::NestedDomId
        include Phlex::Rails::Helpers::NumberToPercentage

        attr_reader :answer, :question

        def initialize(answer, question)
          @answer = answer
          @question = question
        end

        def view_template
          div(
            id: nested_dom_id(question, answer),
            class: "answer flex justify-between items-center flex-row relative"
          ) do
            div(
              style: {
                width: vote_percentage(answer, question)
              },
              class: "absolute rounded border bar"
            )

            div(class: "px-3 py-1 z-10") do
              plain answer.body
            end

            div(class: "px-3 py-1 z-10") do
              vote_percentage(answer, question)
            end
          end
        end

        def vote_percentage(answer, question)
          return "0%" if question.votes_count.zero?

          number_to_percentage((answer.votes_count * 100) / question.votes_count, precision: 1)
        end
      end
    end
  end
end
