class ApartmentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        apartments = Apartment.all 
        render json: apartments, status: :ok
    end

    def show
        apartment = Apartment.find(params[:id])
        if apartment
            render json: apartment, status: :ok
        else
            not_found
        end
    end

    def create
        apartment = Apartment.create!(apartment_params)
        render json: apartment, status: :created
    end

    def update
        apartment = Apartment.find(params[:id])
        if apartment
            Apartment.update!(apartment_params)
            render json: apartment, status: :accepted
        else 
            not_found
        end
    end

    def destroy
        apartment = Apartment.find(params[:id])
        if apartment
            apartment.destroy
            head :no_content
        else
            not_found
        end
    end

    private

    def apartment_params
        params.permit(:number)
    end

    def not_found
        render json: {error: 'Apartment not found'}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
