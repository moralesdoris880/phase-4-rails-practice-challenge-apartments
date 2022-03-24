class LeasesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def create
        tenant = Tenant.find(params[:tenant_id])
        if tenant
            lease = tenant.leases.create!(lease_params)
            render json: lease, status: :created
        else
            not_found
        end
    end

    def destroy
        lease= Lease.find(params[:id])
        if lease
            lease.destroy
            head :no_content
        else
            not_found
        end
    end

    private

    def lease_params
        params.permit(:rent,:tenant_id,:apartment_id)
    end

    def not_found
        render json: {error: 'Not found'}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
