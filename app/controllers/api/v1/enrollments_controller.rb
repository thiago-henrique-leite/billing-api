module Api
  module V1
    class EnrollmentsController < ApplicationController
      include ExceptionTreatable

      def index
        render json: { message: 'Enrollments loaded.', data: Enrollment.all }, status: :ok
      end

      def show
        enrollment = Enrollment.find_by(id: params[:id]) 

        if enrollment.present?
          render json: { message: "Enrollment #{params[:id]} loaded.", data: enrollment}
        else
          render json: { message: "Enrollment #{params[:id]} does not exist." }
        end
      end

      def create
        enrollment = Enrollment.new(enrollment_params)

        if enrollment.save
          render json: { message: 'Registered enrollment and bills created.', data: enrollment.bills }, status: :ok
        else
          render json: { message: 'Not registered enrollment.', data: enrollment.errors }, status: :unprocessable_entity
        end
      end

      def update
        enrollment = Enrollment.find(params[:id])

        if enrollment_params.blank?
          render json: { message: "Enrollment #{id} selected. Enter the parameters to be updated.", data: enrollment }, status: :ok
        else
          enrollment.update_attributes(enrollment_params)

          render json: { message: "Enrollment #{id} updated.", data: enrollment }, status: :ok
        end
      end

      def destroy
        enrollment = Enrollment.find(params[:id])

        render json: { message: "Enrollment #{params[:id]} deleted.", data: enrollment }, status: :ok
      end

      private
      
      def enrollment_params
        params.permit(
          :enabled,
          :due_day, 
          :student_id,
          :total_value, 
          :course_name, 
          :amount_bills, 
          :institution_id, 
          :enrollment_semester, 
          :discount_percentage
        )
      end
    end
  end
end