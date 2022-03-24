class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        tenants = Tenant.all 
        render json: tenants, status: :ok
    end

    def show
        tenant = Tenant.find(params[:id])
        if tenant
            render json: tenant, status: :ok
        else
            not_found
        end
    end

    def create
        tenant = Tenant.create!(tenant_params)
        render json: tenant, status: :created
    end

    def update
        tenant = Tenant.find(params[:id])
        if tenant
            Tenant.update!(tenant_params)
            render json: tenant, status: :accepted
        else 
            not_found
        end
    end

    def destroy
        tenant = Tenant.find(params[:id])
        if tenant
            tenant.destroy
            head :no_content
        else
            not_found
        end
    end

    private

    def tenant_params
        params.permit(:name,:age)
    end

    def not_found
        render json: {error: 'Tenant not found'}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
