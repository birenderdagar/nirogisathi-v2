<?php

namespace App\Modules\Employees\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreEmployeeRequest extends FormRequest
{
    public function rules()
    {
        return [
            'employee_id'=>'required|unique:employees',
            'name'=>'required',
            'email'=>'required|email|unique:employees',
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