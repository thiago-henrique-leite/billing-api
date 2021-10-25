module Api
  module V1
    class BillsController < ApplicationController
      include ExceptionTreatable

      def index
        render json: { message: 'Bills loaded.', data: Bill.all }, status: :ok
      end

      def show
        bill = Bill.find_by(id: params[:id]) 

        if bill.present?
          render json: { message: "Bill #{params[:id]} loaded.", data: bill}
        else
          render json: { message: "Bill #{params[:id]} does not exist." }
        end
      end

      def update
        bill = Bill.find(params[:id])

        if bill_params.blank?
          render json: { message: "Bill #{id} selected. Enter the parameters to be updated.", data: bill }, status: :ok
        else
          bill.update_attributes(bill_params)

          render json: { message: "Bill #{id} updated.", data: bill }, status: :ok
        end
      end

      def destroy
        bill = Bill.find(params[:id]).destroy!
        
        render json: { message: "Bill #{params[:id]} deleted.", data: bill }, status: :ok
      end

      private
      
      def bill_params
        params.permit(:enrollment_id, :status, :due_date, :full_amount, :bill_type)
      end
    end
  end
end