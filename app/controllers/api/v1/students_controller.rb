module Api
  module V1
    class StudentsController < ApplicationController
      include ExceptionTreatable

      def index
        render json: { message: 'Students loaded.', data: Student.all }, status: :ok
      end

      def show
        student = Student.find_by(id: params[:id]) 

        if student.present?
          render json: { message: "Student #{params[:id]} loaded.", data: student}
        else
          render json: { message: "Student #{params[:id]} does not exist." }
        end
      end

      def create
        student = Student.new(student_params)

        if student.save
          render json: { message: 'Student created.', data: student }, status: :ok
        else
          render json: { message: 'Not registered student.', data: student.errors }, status: :unprocessable_entity
        end
      end

      def update
        student = Student.find(params[:id])

        if student_params.blank?
          render json: { message: "Student #{id} selected. Enter the parameters to be updated.", data: student }, status: :ok
        else
          student.update_attributes(student_params)
          
          render json: { message: "Student #{id} updated.", data: student }, status: :ok
        end
      end

      def destroy
        student = Student.find(params[:id])

        render json: { message: "Student #{params[:id]} deleted.", data: student }, status: :ok
      end

      private

      def student_params
        params.permit(
          :cpf,
          :name,
          :phone,
          :gender,
          :enabled,
          :birthday,
          :postal_code,
          :address_number,
          :payment_method
        )
      end
    end
  end
end