<?php

namespace App\Modules\Employees\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEmployeeRequest extends FormRequest
{
    public function rules()
    {
        return [
            'employee_id'=>'required',
            'name'=>'required',
            'email'=>'required|email',
            'phone'=>'required',
            'designation'=>'required',
            'status'=>'required|boolean'
        ];
    }

    public function authorize()
    {
        return true;
    }
}