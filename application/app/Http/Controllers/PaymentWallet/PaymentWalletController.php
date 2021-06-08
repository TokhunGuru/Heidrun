<?php

namespace App\Http\Controllers\PaymentWallet;

use Illuminate\Contracts\View\View;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\View\Factory;
use Illuminate\Contracts\Foundation\Application;

class PaymentWalletController extends Controller
{
    /**
     * @return Application|Factory|View
     */
    public function index()
    {
        return view('payment-wallet.index');
    }
}