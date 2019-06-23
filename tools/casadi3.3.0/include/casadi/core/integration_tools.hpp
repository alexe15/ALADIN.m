/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
 *                            K.U. Leuven. All rights reserved.
 *    Copyright (C) 2011-2014 Greg Horn
 *
 *    CasADi is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    CasADi is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with CasADi; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef CASADI_INTEGRATION_TOOLS_HPP
#define CASADI_INTEGRATION_TOOLS_HPP

#include "casadi/core/function.hpp"

namespace casadi {

  ///@{
  /** \brief Obtain collocation points of specific order and scheme
  \param order Which order (1 to 9 supported)
  \param scheme  'radau' or 'legendre'
  **/
  CASADI_EXPORT
    std::vector<double> collocation_points(int order, const std::string& scheme="radau");
#ifndef SWIG
  CASADI_EXPORT
    std::vector<long double> collocation_pointsL(int order, const std::string& scheme="radau");
#endif // SWIG
  ///@}

  /** \brief Obtain collocation interpolating matrices
  \param tau_root  location of collocation points, as obtained from collocation_points
  \param[out] output_C interpolating coefficients to obtain derivatives
      Length: order+1, order + 1

    \verbatim
      dX/dt @collPoint(j) ~ Sum_i C[j][i]*X@collPoint(i)
    \endverbatim

  \param[out] output_D interpolating coefficients to obtain end state
      Length: order+1
  */
  CASADI_EXPORT void
  collocation_interpolators(const std::vector<double> & tau_root,
                            std::vector< std::vector<double> > &SWIG_OUTPUT(C),
                            std::vector< double > &SWIG_OUTPUT(D));

  // Type of collocation points
  enum CollocationPoints {LEGENDRE, RADAU};

  /** \brief Construct an explicit Runge-Kutta integrator
   * The constructed function has three inputs,
   * corresponding to initial state (x0), parameter (p) and integration time (h)
   * and one output, corresponding to final state (xf).
   *
   * \param f     ODE function with two inputs (x and p) and one output (xdot)
   * \param N     Number of integrator steps
   * \param order Order of interpolating polynomials
   */
  CASADI_EXPORT Function simpleRK(Function f, int N=10, int order=4);

  /** \brief Construct an implicit Runge-Kutta integrator using a collocation scheme
   * The constructed function has three inputs,
   * corresponding to initial state (x0), parameter (p) and integration time (h)
   * and one output, corresponding to final state (xf).
   *
   * \param f      ODE function with two inputs (x and p) and one output (xdot)
   * \param N      Number of integrator steps
   * \param order  Order of interpolating polynomials
   * \param scheme Collocation scheme, as excepted by collocationPoints function.
   * \param solver Solver plugin
   * \param solver_options Options to be passed to the solver plugin
  */
  CASADI_EXPORT
  Function simpleIRK(Function f, int N=10, int order=4, const std::string& scheme="radau",
                       const std::string& solver="newton",
                       const Dict& solver_options = Dict());

  /** \brief Simplified wrapper for the Integrator class
   * Constructs an integrator using the same syntax as simpleRK and simpleIRK.
   * The constructed function has three inputs,
   * corresponding to initial state (x0), parameter (p) and integration time (h)
   * and one output, corresponding to final state (xf).
   *
   * \param f      ODE function with two inputs (x and p) and one output (xdot)
   * \param N      Number of integrator steps
   * \param order  Order of interpolating polynomials
   * \param scheme Collocation scheme, as excepted by collocationPoints function.
  */
  CASADI_EXPORT
  Function simpleIntegrator(Function f, const std::string& integrator="cvodes",
                              const Dict& integrator_options = Dict());
} // namespace casadi

#endif // CASADI_INTEGRATION_TOOLS_HPP
