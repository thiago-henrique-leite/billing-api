module Api
  module V1
    class InstitutionsController < ApplicationController
      include ExceptionTreatable

      def index
        render json: { message: 'Institutions loaded.', data: Institution.all }, status: :ok
      end

      def show
        institution = Institution.find_by(id: params[:id]) 

        if institution.present?
          render json: { message: "Institution #{params[:id]} loaded.", data: institution}
        else
          render json: { message: "Institution #{params[:id]} does not exist." }
        end
      end

      def create
        institution = Institution.new(institution_params)

        if institution.save
          render json: { message: 'Institution created.', data: institution }, status: :ok
        else
          render json: { message: 'Not registered institution.', data: institution.errors }, status: :unprocessable_entity
        end
      end

      def update
        institution = Institution.find(params[:id])

        if institution_params.blank?
          render json: { message: "Institution #{id} selected. Enter the parameters to be updated.", data: institution }, status: :ok
        else
          institution.update_attributes(institution_params)

          render json: { message: "Institution #{id} updated.", data: institution }, status: :ok
        end
      end

      def destroy
        institution = Institution.find(params[:id])

        render json: { message: "Institution #{params[:id]} deleted.", data: institution }, status: :ok
      end

      private

      def institution_params
        params.permit(:name, :cnpj, :kind, :enabled)
      end
    end
  end
end